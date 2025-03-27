pipeline {
    agent { 
        label 'docker-python-label' 
    }

    environment {
        JAVA_HOME = "/opt/java/openjdk"
        PATH = "${JAVA_HOME}/bin:${env.PATH}"
    }

    stages {

        stage('Setup MySQL Service') {
            steps {
                script {
                    sh '''
                        docker run -d --name mysql-service \
                            -e MYSQL_ROOT_PASSWORD=123456 \
                            -e MYSQL_DATABASE=vngo \
                            -p 3306:3306 \
                            mysql:8.0 \
                            --health-cmd="mysqladmin ping" \
                            --health-interval=10s \
                            --health-timeout=5s \
                            --health-retries=3
                    '''
                    sh '''
                        until docker inspect mysql-service --format='{{.State.Health.Status}}' | grep -q "healthy"; do
                            echo "Waiting for MySQL to be healthy..."
                            sleep 5
                        done
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
    }

    post {
        always {
            script {
                sh '''
                    docker stop mysql-service || true
                    docker rm mysql-service || true
                '''
            }
        }
        success {
            echo 'Build and tests completed successfully!'
        }
        failure {
            echo 'Build or tests failed.'
        }
    }
}