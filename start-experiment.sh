EXPERIMENT_NAME=$(date +"%Y_%m_%d_%H_%M")

docker build -t experiment .
mkdir -p output
docker run -d -e HOST_USER_ID=$(id -u) -e HOST_GROUP_ID=$(id -g) -v $PWD/clonedRepositories:/usr/src/app/clonedRepositories -v $PWD/output/$EXPERIMENT_NAME:/usr/src/app/output -v $PWD/projects.csv:/usr/src/app/projects.csv -v $PWD/commits.csv:/usr/src/app/commits.csv --name=generic_merge_experiment_$EXPERIMENT_NAME experiment ./tools/miningframework/install/miningframework/bin/miningframework --threads 1 --injector=injectors.GenericMergeModule --extension=".java" --log-level=TRACE --keep-projects --since=17/07/2010 --until=17/07/2024 /usr/src/app/projects.csv
echo Experiment is running on generic_merge_experiment_${EXPERIMENT_NAME}
