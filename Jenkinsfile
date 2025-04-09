pipeline {
    agent { 
        label 'docker-python-label' 
    }

    environment {
        JAVA_HOME = "/opt/java/openjdk"
        PATH = "${JAVA_HOME}/bin:${env.PATH}"
    }

    stages {

        stage('Check Agent') {
            steps {
                sh 'hostname'
                sh 'docker info'
            }
        }

        stage('Cleanup Environment') {
            steps {
                script {
                    sh '''
                        docker info || echo "Docker not reachable"
                        docker stop mysql-service || true
                        docker rm -f mysql-service || true
                        docker system prune -f || true
                    '''
                }
            }
        }

        stage('Check Java Environment') {
            steps {
                sh '''
                    echo "Java Version:"
                    java -version
                    echo "Java Home: $JAVA_HOME"
                    echo "PATH: $PATH"
                '''
            }
        }

        stage('Setup MySQL Service') {
            steps {
                script {
                    sh '''
                        docker run -d --name mysql-service \
                            -e MYSQL_ROOT_PASSWORD=123456 \
                            -e MYSQL_DATABASE=vngo \
                            -p 3306:3306 \
                            mysql:8.0 \
                    '''
                    sh '''
                        until docker exec mysql-service mysql -uroot -p123456 -e "SELECT 1;" > /dev/null 2>&1; do
                            echo "Waiting for MySQL to be ready..."
                            sleep 5
                        done
                        echo "MySQL is ready!"
                    '''
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh '''
                    chmod +x ./mvnw
                    ./mvnw test -D"spring.profiles.active"="dev"
                '''
            }
        }

        stage('Build with Maven') {
            steps {
                sh './mvnw package -DskipTests'
            }
        }

        stage('Report Status') {
            steps {
                script {
                    def commitSha = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
                    def status = currentBuild.result == null ? 'success' : currentBuild.result.toLowerCase()
                    withCredentials([string(credentialsId: 'jenkin-with-status-repohook', variable: 'GITHUB_TOKEN')]) {
                        step([
                            $class: 'GitHubCommitStatusSetter',
                            reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://github.com/NP10t/VNGo_Jenkins"],
                            commitShaSource: [$class: "ManuallyEnteredShaSource", sha: commitSha],
                            contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "ci/jenkins"],
                            statusResultSource: [$class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", state: status, message: "Build ${status}"]]],
                            credsId: 'jenkin-with-status-repohook',
                        ])
                    }
                }
            }
        }
    }


}