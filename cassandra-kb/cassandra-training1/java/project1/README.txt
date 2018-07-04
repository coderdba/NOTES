apt-get install maven -y
mvn  archetype:generate -DgroupId=com.admatic -DartifactId=Cassandra-Java  -DarchetypeArtifactId=maven-archetype-quickstart
cd Cassandra-Java

mvn compile
mvn exec:java -Dexec.mainClass="com.admatic.CreateAndPopulateKeyspace"
