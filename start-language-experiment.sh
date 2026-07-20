#!/bin/bash

source .env.local

EXPERIMENT_NAME=${EXPERIMENT_NAME-$(date +"%Y_%m_%d_%H_%M")}
EXECUTION_FOLDER=${EXECUTION_FOLDER-$PWD/executions/$EXPERIMENT_NAME}
OUTPUT_FOLDER=$EXECUTION_FOLDER/output
THREADS=${THREADS-1}
LANGUAGE=${LANGUAGE}
LANGUAGE_SUFFIX=${LANGUAGE_SUFFIX}

if [ -z "$CONTAINER_NAME_SUFFIX" ]; then
    CONTAINER_NAME=generic_merge_experiment_${LANGUAGE}_${EXPERIMENT_NAME}
else
    CONTAINER_NAME=generic_merge_experiment_${LANGUAGE}_${EXPERIMENT_NAME}_${CONTAINER_NAME_SUFFIX}
fi

if ! docker image inspect experiment-${LANGUAGE} >/dev/null 2>&1; then
    echo "Missing Docker image experiment-${LANGUAGE}."
    echo "Build it first with: make build-js-image"
    exit 1
fi

mkdir -p $OUTPUT_FOLDER
cp input/${LANGUAGE}/projects.csv $OUTPUT_FOLDER/projects.csv
cp input/${LANGUAGE}/commits.csv $OUTPUT_FOLDER/commits.csv
docker run -d \
    --pids-limit=-1 \
    --ulimit nproc=65535:65535 \
    --security-opt seccomp=unconfined \
    -e HOST_USER_ID=$(id -u) \
    -e HOST_GROUP_ID=$(id -g) \
    -v $EXECUTION_FOLDER/clonedRepositories:/usr/src/app/clonedRepositories \
    -v $OUTPUT_FOLDER:/usr/src/app/output \
    -v $OUTPUT_FOLDER/projects.csv:/usr/src/app/projects.csv \
    -v $OUTPUT_FOLDER/commits.csv:/usr/src/app/commits.csv \
    --name=$CONTAINER_NAME \
    experiment-${LANGUAGE} \
    ./tools/miningframework/install/miningframework/bin/miningframework \
    --threads $THREADS \
    --injector=injectors.GenericMergeDiff3Module \
    --extension="${LANGUAGE_SUFFIX}" \
    --log-level=TRACE \
    --keep-projects \
    --project-commit-hashes-file=commits.csv \
    /usr/src/app/projects.csv
echo Experiment is running on $CONTAINER_NAME
