FROM ghcr.io/jpedroh/last-merge:main as last_merge

FROM ghcr.io/jpedroh/miningframework:fix-unstructured-merge as mining_framework

FROM ghcr.io/jpedroh/jdime:develop as jdime

FROM openjdk:8

RUN  set -ex; \
     \
     curl -o /usr/local/bin/su-exec.c https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c; \
     \
     fetch_deps='gcc libc-dev'; \
     apt-get update; \
     apt-get install -y --no-install-recommends $fetch_deps; \
     rm -rf /var/lib/apt/lists/*; \
     gcc -Wall \
         /usr/local/bin/su-exec.c -o/usr/local/bin/su-exec; \
     chown root:root /usr/local/bin/su-exec; \
     chmod 0755 /usr/local/bin/su-exec; \
     rm /usr/local/bin/su-exec.c; \
     \
     apt-get purge -y --auto-remove $fetch_deps

WORKDIR /usr/src/app

COPY --from=mining_framework ./usr/local/bin/miningframework ./tools/miningframework

COPY --from=last_merge ./last-merge ./dependencies/last-merge
COPY --from=jdime ./usr/bin/jdime ./dependencies/jdime
RUN wget -O ./dependencies/spork.jar https://github.com/ASSERT-KTH/spork/releases/download/v0.5.1/spork-0.5.1.jar
COPY ./vendor/mergiraf ./dependencies/mergiraf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

USER root

CMD ["./tools/miningframework/install/miningframework/bin/miningframework"]
