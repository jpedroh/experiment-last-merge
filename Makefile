.PHONY: build-language-image run-language-experiment

build-language-image:
	docker build --pull -f Dockerfile.diff3 -t experiment-$(LANGUAGE) .

run-language-experiment:
	LANGUAGE=$(LANGUAGE) LANGUAGE_SUFFIX=$(LANGUAGE_SUFFIX) bash start-language-experiment.sh
