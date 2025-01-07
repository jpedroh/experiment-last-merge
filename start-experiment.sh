#!/bin/bash

source .env.local

EXPERIMENT_NAME=${EXPERIMENT_NAME-$(date +"%Y_%m_%d_%H_%M")}
EXECUTION_FOLDER=${EXECUTION_FOLDER-$PWD/executions/$EXPERIMENT_NAME}
OUTPUT_FOLDER=$EXECUTION_FOLDER/output
THREADS=${THREADS-1}

if [ -z "$CONTAINER_NAME_SUFFIX" ]; then
    CONTAINER_NAME=generic_merge_experiment_${EXPERIMENT_NAME}
else
    CONTAINER_NAME=generic_merge_experiment_${EXPERIMENT_NAME}_${CONTAINER_NAME_SUFFIX}
fi

docker build --pull -t experiment .
mkdir -p $OUTPUT_FOLDER
cp input/projects.csv $OUTPUT_FOLDER/projects.csv
cp input/commits.csv $OUTPUT_FOLDER/commits.csv
docker run -d -e HOST_USER_ID=$(id -u) -e HOST_GROUP_ID=$(id -g)  -v $EXECUTION_FOLDER/clonedRepositories:/usr/src/app/clonedRepositories -v $OUTPUT_FOLDER:/usr/src/app/output -v $PWD/input/projects.csv:/usr/src/app/projects.csv -v $PWD/input/commits.csv:/usr/src/app/commits.csv --name=$CONTAINER_NAME experiment ./tools/miningframework/install/miningframework/bin/miningframework --threads $THREADS --injector=injectors.GenericMergeModule --access-key=${GITHUB_ACCESS_KEY} --extension=".java" --log-level=TRACE --keep-projects --project-commit-hashes-file=commits.csv /usr/src/app/projects.csv
echo Experiment is running on $CONTAINER_NAME
