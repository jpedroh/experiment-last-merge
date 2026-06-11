#!/bin/bash

source .env.local

EXPERIMENT_NAME=${EXPERIMENT_NAME-$(date +"%Y_%m_%d_%H_%M")}
EXECUTION_FOLDER=${EXECUTION_FOLDER-$PWD/executions/$EXPERIMENT_NAME}
OUTPUT_FOLDER=$EXECUTION_FOLDER/output
THREADS=${THREADS-1}

if [ -z "$CONTAINER_NAME_SUFFIX" ]; then
    CONTAINER_NAME=generic_merge_experiment_javascript_${EXPERIMENT_NAME}
else
    CONTAINER_NAME=generic_merge_experiment_javascript_${EXPERIMENT_NAME}_${CONTAINER_NAME_SUFFIX}
fi

docker build --pull -f Dockerfile.diff3 -t experiment-javascript .
mkdir -p $OUTPUT_FOLDER
cp input/javascript/projects.csv $OUTPUT_FOLDER/projects.csv
cp input/javascript/commits.csv $OUTPUT_FOLDER/commits.csv
docker run -d \
    --pids-limit=-1 \
    --ulimit nproc=65535:65535 \
    --security-opt seccomp=unconfined \
    -e HOST_USER_ID=$(id -u) \
    -e HOST_GROUP_ID=$(id -g) \
    -v $EXECUTION_FOLDER/clonedRepositories:/usr/src/app/clonedRepositories \
    -v $OUTPUT_FOLDER:/usr/src/app/output \
    -v $PWD/input/javascript/projects.csv:/usr/src/app/projects.csv \
    -v $PWD/input/javascript/commits.csv:/usr/src/app/commits.csv \
    --name=$CONTAINER_NAME \
    experiment-javascript \
    ./tools/miningframework/install/miningframework/bin/miningframework \
    --threads $THREADS \
    --injector=injectors.GenericMergeDiff3Module \
    --extension=".js" \
    --log-level=TRACE \
    --keep-projects \
    --project-commit-hashes-file=commits.csv \
    /usr/src/app/projects.csv
echo Experiment is running on $CONTAINER_NAME
