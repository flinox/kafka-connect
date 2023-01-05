FROM confluentinc/cp-kafka-connect-base:latest

ENV TZ=UTC

COPY ./plugins/ /usr/share/confluent-hub-components/
COPY ./config/ /config/
COPY ./log/log4j2.properties /etc/kafka/

EXPOSE 8083

CMD ["/bin/connect-distributed","/config/kapacitor-connect-distributed.properties"]
