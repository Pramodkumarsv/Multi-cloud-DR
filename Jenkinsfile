pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
        SONAR_HOST_URL = 'http://10.20.44.72:9000'
        SONAR_PROJECT_KEY = 'calculator'
        SONAR_TOKEN = 'sqp_20f17190497ebb7e0c2f47ec34491b99850f4d9d'
    }

    stages {
        stage('Setup Environment') {
            steps {
                sh 'sudo apt update'
                sh 'sudo apt install maven -y'
                sh 'sudo apt install openjdk-17-jdk -y'
                sh 'export JAVA_HOME=$JAVA_HOME'
            }
        }

        stage('Checkout Source Code') {
            steps {
                git url: 'https://github.com/Pramodkumarsv/Calculator.git', branch: 'master'
            }
        }

        stage('Build and Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                sh '''
                mvn sonar:sonar \
                    -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                    -Dsonar.host.url=${SONAR_HOST_URL} \
                    -Dsonar.token=${SONAR_TOKEN}
                '''
            }
        }
    }
}

