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

                withSonarQubeEnv(credentialsId: 'sonarqube_cred',installationName: 'sonar') {

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

        stage("UPLOAD THE ARTIFACT INTO NEXUS"){
            
            steps{
                
            nexusArtifactUploader artifacts: 
            [
                [
                    artifactId: '${POM_ARTIFACTID}',
                    classifier: '', file: 'target/: ${POM_ARTIFACTID}-${POM_VERSION}.${POM_PACKAGING}',
                    type: '${POM_PACKAGING}'
                    ]
            ],
            credentialsId: 'Nexus_crd',
            groupId: '${POM_GROUPID}',
            nexusUrl: '13.127.59.129:8081',
            nexusVersion: 'nexus3',
            protocol: 'http',
            repository: 'Demoapp-release',
            version: '${POM_VERSION}'

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