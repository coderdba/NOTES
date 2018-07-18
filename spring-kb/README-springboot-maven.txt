TO RUN JAR AS WEB-SERVER WITH INBUILT TOMCAT CONTAINER

1. pom.xml must have this (if using Maven)
  <build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <version>1.5.2.RELEASE</version>
            <executions>
                <execution>
                    <goals>
                        <goal>repackage</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
   </build>
   
 2. Build with option "clean install" or "package"
 If using Eclipse:  
 Click on the project name and keep the control of click there
 Do Run --> Run As --> Build --> "clean install" or "package"
 
		 If you just do 'build' then you may get the following error:
		 [ERROR] Unknown lifecycle phase "build". 
		 You must specify a valid lifecycle phase or a goal in the format <plugin-prefix>:<goal> 
		 or <plugin-group-id>:<plugin-artifact-id>[:<plugin-version>]:<goal>. 
		 Available lifecycle phases are: validate, initialize, generate-sources, process-sources, 
		 generate-resources, process-resources, compile, process-classes, generate-test-sources, 
		 process-test-sources, generate-test-resources, process-test-resources, test-compile, 
		 process-test-classes, test, prepare-package, package, pre-integration-test, 
		 integration-test, post-integration-test, verify, install, deploy, pre-clean, 
		 clean, post-clean, pre-site, site, post-site, site-deploy
 
 3. Start the application as follows:
 java -jar ComGmSpringBoot1Jar-0.0.1-SNAPSHOT.jar
 
 4. Access URL as follows:
 http://localhost:8080/helloworld (and other URLs of various controllers)
