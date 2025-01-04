FROM ghcr.io/jpedroh/last-merge:main as last_merge

FROM ghcr.io/jpedroh/miningframework:fix-unstructured-merge as mining_framework

FROM ghcr.io/jpedroh/jdime:develop as jdime

# FROM ghcr.io/jpedroh/mergiraf:main as mergiraf

FROM aldanial/cloc as cloc

FROM ubuntu:24.04

WORKDIR /usr/src/app

COPY --from=last_merge ./last-merge ./tools/last-merge
COPY --from=jdime ./usr/bin/jdime ./tools/jdime
COPY --from=mining_framework ./usr/local/bin/miningframework ./tools/miningframework
COPY --from=cloc /usr/src/cloc ./dependencies/cloc
# COPY --from=mergiraf /usr/src/mergiraf/target/release/mergiraf ./dependencies/mergiraf

RUN ldd --version

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;
    
# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# ENTRYPOINT ["/entrypoint.sh"]

# USER root

CMD ["./tools/miningframework/install/miningframework/bin/miningframework"]
