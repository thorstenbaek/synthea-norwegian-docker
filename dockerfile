FROM debian as BUILD
RUN apt-get update && apt-get install -y git
WORKDIR /opt
RUN git clone https://github.com/synthetichealth/synthea.git
WORKDIR /opt/synthea

WORKDIR /opt
RUN git clone https://github.com/synthetichealth/synthea-international.git

FROM openjdk:11 as GENERATOR
COPY --from=BUILD /opt/synthea /opt/synthea
COPY --from=BUILD /opt/synthea-international/no/ /opt/synthea
WORKDIR /opt/synthea

ENV COUNT=5
ENV COUNTY=Viken
ENV CITY=Lillestrøm

RUN echo "#!/bin/bash \n ./run_synthea -p ${COUNT} ${COUNTY} ${CITY}" > ./entrypoint.sh
RUN chmod +x ./entrypoint.sh 

RUN ./entrypoint.sh

FROM nginx:stable
COPY default.conf.template /etc/nginx/conf.d/

COPY --from=GENERATOR /opt/synthea/output /var/share/nginx/html

CMD /bin/bash -c "envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf \	
			&& nginx -g 'daemon off;'"

