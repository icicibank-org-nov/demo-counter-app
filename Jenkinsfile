 pipeline {
    agent any

     tools {

    maven "maven3.9.2"
    
    }

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

                withSonarQubeEnv(credentialsId: 'sonar_auth',installationName: 'sonarqube') {

                    sh "mvn clean package sonar:sonar"
                }
            }
        }

        stage('QUALITY GATE'){

            steps{

                waitForQualityGate abortPipeline: false, credentialsId: 'sonar_auth'
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
                }
            }
        }

        stage("UPLOAD THE ARTIFACT INTO NEXUS") {
          
            steps {

                script {

            def readpomVersion = readMavenPom file: 'pom.xml'

            def nexusRepo = readpomVersion.version.endsWith("SNAPSHOT") ? "Demoapp-snapshot" : "Demoapp-release"

            nexusArtifactUploader artifacts: [
                [
                    artifactId: 'spring-boot-starter-paren',
                    classifier: '',
                    file: 'target/Uber.jar',
                    type: 'jar'
                ]
            ],
            credentialsId: 'Nexus_crd',
            groupId: 'com.example',
            nexusUrl: '13.127.59.129:8081',
            nexusVersion: 'nexus3',
            protocol: 'http',
            repository: nexusRepo ,
            version: "${readpomVersion.version}"
                  }
             } 
        }

        stage("BUILD DOCKER IMAGE"){

            steps{

                script{
                
                  sh "docker build -t $JOB_NAME:v1.$BUILD_ID ."
                  sh "docker tag image $JOB_NAME:v1.$BUILD_ID lokeshsdockerhub/$JOB_NAME:v1.$BUILD_ID"
                  sh "docker tag image $JOB_NAME:v1.$BUILD_ID lokeshsdockerhub/$JOB_NAME:latest"

                }
            }
        }

    stage ('Send Email') {
        steps{
          echo "Mail Stage";

         mail to: "lokeshreddy4590@gmail.com",
         cc: 'lokeshreddy05690@gmail.com', charset: 'UTF-8', 
         from: 'lokeshreddy05690@gmail.com', mimeType: 'text/html', replyTo: '', 
         bcc: '',
         subject: "CI: Project name -> ${env.JOB_NAME}",
         body: "<b>Example</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}";
         
        }
        
    } 
    
       
            
    }

    
}