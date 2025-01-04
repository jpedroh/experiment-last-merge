FROM ghcr.io/jpedroh/last-merge:main as last_merge

FROM ghcr.io/jpedroh/miningframework:fix-unstructured-merge as mining_framework

FROM ghcr.io/jpedroh/jdime:develop as jdime

# FROM ghcr.io/jpedroh/mergiraf:main as mergiraf

FROM aldanial/cloc as cloc

FROM openjdk:11

WORKDIR /usr/src/app

COPY --from=last_merge ./last-merge ./tools/last-merge
COPY --from=jdime ./usr/bin/jdime ./tools/jdime
COPY --from=mining_framework ./usr/local/bin/miningframework ./tools/miningframework
COPY --from=cloc /usr/src/cloc ./dependencies/cloc
# COPY --from=mergiraf /usr/src/mergiraf/target/release/mergiraf ./dependencies/mergiraf

RUN ldd --version

# ENTRYPOINT ["/entrypoint.sh"]

# USER root

CMD ["./tools/miningframework/install/miningframework/bin/miningframework"]
