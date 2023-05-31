 pipeline {
    agent any

    maven: "maven3.9.2"

    stages{

        stage('CHECKOUT CODE'){
            
            steps{
                 git branch: 'main', credentialsId: 'Jenkins_Github_crd', url: 'https://github.com/icicibank-org-nov/demo-counter-app.git'
            }

        }

        stage('UNITTEST CASES'){

            steps{

                sh "mvn test"
            }
        }

        stage('INTEGRATING UNIT TESTCASES'){

            steps{

                sh "mvn verify -DskipUnitTests"
            }
        }

        stage('MAVEN BUILD'){

            steps{

                sh "mvn clean install"
            }
        }

        stage('BUILD & SONARQUBE ANALYSIS'){
            
            steps{

                withSonarQubeEnv(credentialsId: 'sonarqube_cred') {

                    sh "mvn clean package sonar:sonar"
                }
            }
        }

        stage('QUALITY GATE'){

            steps{

                waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube_cred'
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('UPLOAD ARTIFACT INTO NEXUS'){

            steps{
            
             def readPomVersion = readMavenPom file: 'pom.xml'

             def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "mavenwebapp-Snapshot" : "mavenwebapp-release"

    	nexusArtifactUploader artifacts: 
		[
			[
			artifactId: 'maven-web-application',
			classifier: '', file: 'target/*.war',
			type: 'war'
			]
		], 
		credentialsId: 'Nexus_crd',
		groupId: 'com.mt',
		nexusUrl: '13.127.243.212:8081',
		nexusVersion: 'nexus3',
		protocol: 'http',
		repository: nexusRepo,
		version: "${readpomVersion.version}"    

            }
        }

        post {
            always{
                archiveArtifacts artifacts: '*.csv', onlyIfSuccessful: true
                
                emailext to: "lokeshreddy4590@gmail.com",
                subject: "jenkins build:${currentBuild.currentResult}: ${env.JOB_NAME}",
                body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}",
                attachmentsPattern: '*.csv'
                
            cleanWs()
            }
        }

    }

}