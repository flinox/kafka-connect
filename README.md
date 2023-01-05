# Kafka Connect 
Imagem do Kafka Connect que ficará responsável por executar os connectores de source e sink não geridos pela confluent.
Build by: Kapacitor de Fluxo           

### Plugins
Caso seja necessário instalar novos plugins não geridos pela confluent, coloque os mesmos na seguinte pasta:
```
./plugins
```
Já estão instalados os plugins para JDBC e ELASTICSEARCH

### Criando os connectores
Crie os connectores normalmente usando a API REST disponivel na porta **8083**, para maiores informações consulte a documentação da confluent.  

### Referenciando as keys no connector
Com as credenciais de acesso já criadas no arquivo **access.properties**, no connector você deverá referenciar o valor desejado usando a seguinte sintaxe de exemplo **${file:/properties/access.properties:POSTGRE_PASS}**.

**Não passe o usuário e senha de forma explícita no connector!**


#### Exemplo:
```
name=src-postgre-eda-application-created
connector.class=io.confluent.connect.jdbc.JdbcSourceConnector
tasks.max=1
topic.prefix=eda-application-created
connection.url=${file:/properties/access.properties:POSTGRE_CONN}
connection.user=${file:/properties/access.properties:POSTGRE_USER}
connection.password=${file:/properties/access.properties:POSTGRE_PASS}
query=SELECT * FROM (SELECT id, applicant_decision_date, application_date, application_decision_date, application_status, application_type, applicant, applying_to, preparer, term, createdate, recordactive, createuser FROM kapacitor.application) t
schema.pattern=kapacitor
mode=timestamp
timestamp.column.name=createdate
numeric.mapping=best_fit
transforms=createKey,AddNamespaceValue,AddNamespaceKey
transforms.createKey.type=org.apache.kafka.connect.transforms.ValueToKey
transforms.createKey.fields=id
transforms.AddNamespaceValue.type=org.apache.kafka.connect.transforms.SetSchemaMetadata$Value
transforms.AddNamespaceValue.schema.name=br.com.cogna.eda_application_created
transforms.AddNamespaceKey.type=org.apache.kafka.connect.transforms.SetSchemaMetadata$Key
transforms.AddNamespaceKey.schema.name=br.com.cogna.eda_application_created
key.converter.auto.register.schemas=false
key.converter.use.latest.version=true
value.converter.auto.register.schemas=false
value.converter.use.latest.version=true
key.converter.key.subject.name.strategy=io.confluent.kafka.serializers.subject.TopicNameStrategy
key.converter.enhanced.avro.schema.support=true
key.converter.connect.meta.data=false
value.converter.value.subject.name.strategy=io.confluent.kafka.serializers.subject.TopicNameStrategy
value.converter.enhanced.avro.schema.support=true
value.converter.connect.meta.data=false
```

## Referencias

### Image base for Kafka Connect
https://hub.docker.com/r/confluentinc/cp-kafka-connect-base

### Kafka Connect use guide
https://docs.confluent.io/home/connect/userguide.html

https://docs.confluent.io/platform/current/installation/docker/config-reference.html#kconnect-long-configuration

--
