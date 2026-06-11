.PHONY: build-js-image run-js-experiment

build-js-image:
	docker build --pull -f Dockerfile.diff3 -t experiment-javascript .

run-js-experiment:
	bash start-javascript-experiment.sh
