FROM debian as GIT
RUN apt-get update && apt-get install -y git
WORKDIR /opt
RUN git clone https://github.com/thorstenbaek/synthea.git
WORKDIR /opt/synthea
RUN git checkout master
RUN git pull

WORKDIR /opt
RUN git clone https://github.com/synthetichealth/synthea-international.git

FROM gradle:7.2.0-jdk8 as BUILD
COPY --from=GIT /opt/synthea /opt/synthea
COPY --from=GIT /opt/synthea-international/no/ /opt/synthea
COPY synthea.properties /opt/synthea/src/main/resources
WORKDIR /opt/synthea

ENV COUNT=100
ENV COUNTY=Viken
ENV CITY=Lillestrøm

RUN echo "#!/bin/bash \n ./run_synthea -p 1 Oslo Oslo" > ./entrypoint.sh
RUN chmod +x ./entrypoint.sh 
RUN ./entrypoint.sh
# Trigger build of Synthea

CMD ["/bin/bash", "-c", "./run_synthea -p ${COUNT} ${COUNTY} ${CITY}"]
