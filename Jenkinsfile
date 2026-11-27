pipeline {
    agent {
        kubernetes {
            cloud 'kubernetes'
            namespace 'jenkins'
            defaultContainer 'kubectl'
            yamlFile 'ci/jenkins/agent.yaml'
        }
    }

    environment {
        APP_NAMESPACE = 'default'
    }

    options {
        disableConcurrentBuilds()
        timeout(time: 20, unit: 'MINUTES')
    }

    stages {
        stage('Prepare Configuration') {
            steps {
                sh '''
                    set -eu
                    kubectl -n "$APP_NAMESPACE" apply -f k8s/secret.yaml
                    kubectl -n "$APP_NAMESPACE" create configmap cengage-config \
                        --from-env-file=k8s/app.env --dry-run=client -o yaml > cengage-config.generated.yaml
                    kubectl -n "$APP_NAMESPACE" apply -f cengage-config.generated.yaml
                    rm cengage-config.generated.yaml
                '''
            }
        }

        stage('Deploy Databases') {
            steps {
                sh '''
                    set -eu
                    kubectl -n "$APP_NAMESPACE" apply -f k8s/catalog-db.yaml
                    kubectl -n "$APP_NAMESPACE" apply -f k8s/user-db.yaml
                    kubectl -n "$APP_NAMESPACE" rollout status deployment/catalog-db --timeout=300s
                    kubectl -n "$APP_NAMESPACE" rollout status deployment/user-db --timeout=300s
                '''
            }
        }

        stage('Deploy Application') {
            steps {
                // Reuse the existing deployment as the single application environment.
                sh '''
                    set -eu
                    kubectl -n "$APP_NAMESPACE" apply -f k8s/app-blue.yaml
                    kubectl -n "$APP_NAMESPACE" rollout status deployment/cengage-blue --timeout=300s
                    kubectl -n "$APP_NAMESPACE" apply -f k8s/app-service.yaml
                '''
            }
        }

        stage('Show Deployment') {
            steps {
                sh '''
                    set -eu
                    kubectl -n "$APP_NAMESPACE" get deployments
                    kubectl -n "$APP_NAMESPACE" get pods -o wide
                    kubectl -n "$APP_NAMESPACE" get service cengage-service
                '''
            }
        }
    }

    post {
        success {
            echo 'Application deployed: http://192.168.56.111:30080'
        }
        failure {
            sh '''
                kubectl -n "$APP_NAMESPACE" get pods -o wide || true
                kubectl -n "$APP_NAMESPACE" get events --sort-by=.metadata.creationTimestamp || true
            '''
        }
    }
}
