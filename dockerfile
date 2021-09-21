FROM debian as BUILD
RUN apt-get update && apt-get install -y git
WORKDIR /opt
RUN git clone https://github.com/synthetichealth/synthea.git
WORKDIR /opt/synthea
RUN git fetch
# RUN git checkout origin/create-norwegian-docker
# RUN git checkout v2.6.1
# RUN git checkout v2.7.0
RUN git checkout master

WORKDIR /opt
RUN git clone https://github.com/synthetichealth/synthea-international.git
# WORKDIR /opt/synthea-international
# COPY //opt/synthea-international/no/* //opt/synthea

# # FROM openjdk:latest
# # COPY --from=BUILD /opt/synthea /opt/synthea
# # WORKDIR /opt/synthea
# # CMD [ "/opt/synthea/run_synthea" ]

FROM openjdk:11
COPY --from=BUILD /opt/synthea /opt/synthea
COPY --from=BUILD /opt/synthea-international /opt/synthea-international
# COPY names.yml /opt/synthea-international/no/src/main/resources
WORKDIR /opt/synthea
CMD [ "/bin/bash"]


