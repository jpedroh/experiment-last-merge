EXPERIMENT_NAME=${EXPERIMENT_NAME-$(date +"%Y_%m_%d_%H_%M")}

EXECUTIONS_FOLDER=$PWD/executions/$EXPERIMENT_NAME
OUTPUT_FOLDER=$EXECUTIONS_FOLDER/output

docker build --pull -t experiment .
mkdir -p $EXECUTIONS_FOLDER
cp projects.csv $OUTPUT_FOLDER/projects.csv
cp commits.csv $OUTPUT_FOLDER/commits.csv
docker run -d -e HOST_USER_ID=$(id -u) -e HOST_GROUP_ID=$(id -g) -v $EXECUTIONS_FOLDER/clonedRepositories:/usr/src/app/clonedRepositories -v $OUTPUT_FOLDER:/usr/src/app/output -v $PWD/projects.csv:/usr/src/app/projects.csv -v $PWD/commits.csv:/usr/src/app/commits.csv --name=generic_merge_experiment_$EXPERIMENT_NAME experiment ./tools/miningframework/install/miningframework/bin/miningframework --threads 1 --injector=injectors.GenericMergeModule --extension=".java" --log-level=TRACE --keep-projects --include-pull-request-branches /usr/src/app/projects.csv
echo Experiment is running on generic_merge_experiment_${EXPERIMENT_NAME}
