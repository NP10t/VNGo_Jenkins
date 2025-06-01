
                    echo $JAVA_HOME
                    chmod +x ./mvnw
                    ./mvnw test -D"spring.profiles.active"="dev"
                