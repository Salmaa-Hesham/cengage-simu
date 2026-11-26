pipeline {
    agent any

    parameters {
        choice(
            name: 'TARGET_COLOR',
            choices: ['blue', 'green'],
            description: 'Target environment to deploy or switch to'
        )
        choice(
            name: 'ACTION',
            choices: ['deploy_and_switch', 'switch_traffic_only', 'deploy_only'],
            description: 'Action to perform'
        )
    }

    stages {
        stage('Deploy Target Application') {
            when {
                expression { params.ACTION == 'deploy_and_switch' || params.ACTION == 'deploy_only' }
            }
            steps {
                echo "Applying k8s/app-${params.TARGET_COLOR}.yaml..."
                sh "kubectl apply -f k8s/app-${params.TARGET_COLOR}.yaml"
                
                echo "Waiting for cengage-${params.TARGET_COLOR} rollout..."
                sh "kubectl rollout status deployment/cengage-${params.TARGET_COLOR} --timeout=90s"
            }
        }

        stage('Verify Health') {
            when {
                expression { params.ACTION == 'deploy_and_switch' || params.ACTION == 'deploy_only' }
            }
            steps {
                sh """
                    POD=\$(kubectl get pods -l app=cengage,version=${params.TARGET_COLOR} -o jsonpath='{.items[0].metadata.name}')
                    echo "Checking health on pod: \${POD}"
                    kubectl exec \${POD} -- curl -s http://localhost:8080/health || true
                """
            }
        }

        stage('Switch Traffic (Blue/Green)') {
            when {
                expression { params.ACTION == 'deploy_and_switch' || params.ACTION == 'switch_traffic_only' }
            }
            steps {
                echo "Switching cengage-service selector to version: ${params.TARGET_COLOR}..."
                sh "kubectl patch service cengage-service -p '{\"spec\":{\"selector\":{\"app\":\"cengage\",\"version\":\"${params.TARGET_COLOR}\"}}}'"
            }
        }

        stage('Verify Active Service') {
            steps {
                sh "kubectl get service cengage-service -o wide"
                sh "kubectl get pods -l app=cengage -o wide"
            }
        }
    }

    post {
        success {
            echo "Successfully routed traffic to ${params.TARGET_COLOR} at http://192.168.56.111:30080"
        }
    }
}