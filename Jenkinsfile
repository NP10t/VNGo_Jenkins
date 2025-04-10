pipeline {
    // agent { 
    //     label 'docker-python-label' 
    // }

    agent { 
        label 'docker-agent'
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
                withCredentials([
                    usernamePassword(credentialsId: 'mysql-usernam-password', usernameVariable: 'MYSQL_USER', passwordVariable: 'MYSQL_PASSWORD'),
                    string(credentialsId: 'database-name', variable: 'MYSQL_DB')
                    ]) {
                    script {
                        sh '''
                            docker run -d --name mysql-service \
                                -e MYSQL_ROOT_PASSWORD=${MYSQL_PASSWORD} \
                                -e MYSQL_DATABASE=${MYSQL_DB} \
                                -p 3306:3306 \
                                mysql:8.0 \
                        '''
                        sh '''
                            until docker exec mysql-service mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1;" > /dev/null 2>&1; do
                                echo "Waiting for MySQL to be ready..."
                                sleep 5
                            done
                            echo "MySQL is ready!"
                        '''
                    }
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
    }

    post {
        always {
            script {
                sh '''
                    echo "Cleaning up after pipeline..."
                    docker stop mysql-service || true
                    docker rm -f mysql-service || true
                '''
            }
        }
    }


}