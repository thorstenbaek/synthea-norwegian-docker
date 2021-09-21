FROM debian as BUILD
RUN apt-get update && apt-get install -y git
WORKDIR /opt
RUN git clone https://github.com/synthetichealth/synthea.git
WORKDIR /opt/synthea

WORKDIR /opt
RUN git clone https://github.com/synthetichealth/synthea-international.git

FROM openjdk:11
COPY --from=BUILD /opt/synthea /opt/synthea
COPY --from=BUILD /opt/synthea-international/no/ /opt/synthea
WORKDIR /opt/synthea
CMD [ "/bin/bash"]


