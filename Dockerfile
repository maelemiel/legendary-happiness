FROM eclipse-temurin:21-jdk as builder

RUN mkdir /build
WORKDIR /build

RUN apt update && apt install -y \
    ca-certificates \
    wget \
    git

RUN wget -O BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

RUN git config --global --unset core.autocrlf || exit 0
RUN java -jar BuildTools.jar --rev 1.21.3
RUN mv spigot-*.jar spigot.jar

FROM eclipse-temurin:21-jre

RUN mkdir -p /server /minecraft/bundler && \
    adduser --system --shell /bin/bash --group minecraft && \
    chown -R minecraft:minecraft /server /minecraft

COPY --from=builder --chown=minecraft:minecraft /build/spigot.jar /server

USER minecraft
WORKDIR /minecraft

CMD ["java", "-Xms4G", "-Xmx16G", "-XX:+UseG1GC", "-jar", "/server/spigot.jar", "nogui"]
