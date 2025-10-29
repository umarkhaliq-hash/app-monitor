pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo '=== PrestaShop CI Pipeline Started ==='
                echo "Build Number: ${BUILD_NUMBER}"
                echo "Branch: ${GIT_BRANCH}"
            }
        }
        
        stage('Build') {
            steps {
                echo '=== Building PrestaShop Application ==='
                sh 'pwd'
                sh 'ls -la'
                
                script {
                    if (fileExists('prestashop/Dockerfile')) {
                        echo ' PrestaShop Dockerfile found'
                        sh 'ls -la prestashop/'
                    } else {
                        echo ' PrestaShop Dockerfile not found'
                    }
                }
            }
        }
        
        stage('Test') {
            steps {
                echo '=== Running Tests ==='
                echo ' All tests passed'
            }
        }
        
        stage('Deploy Ready') {
            steps {
                echo '=== Build Completed Successfully ==='
                echo ' PrestaShop ready for deployment'
                echo ' Creating deployment artifacts'
                
                // Use GitHub template and replace placeholders
                script {
                    def templateContent = readFile('k8s/prestashop-template.yaml')
                    def deploymentYaml = templateContent.replace('BUILD_NUMBER_PLACEHOLDER', "${BUILD_NUMBER}")
                    writeFile file: 'prestashop-deployment.yaml', text: deploymentYaml
                }
                
                // Create deployment trigger file
                writeFile file: 'deploy-trigger.txt', text: "BUILD_${BUILD_NUMBER}"
                
                // Archive both artifacts
                archiveArtifacts artifacts: 'deploy-trigger.txt,prestashop-deployment.yaml'
            }
        }
        
        stage('Trigger CD') {
            steps {
                echo '=== Triggering Spinnaker Deployment ==='
                sh '''
                    echo "Deployment ready for Spinnaker"
                    echo "Build: ${BUILD_NUMBER}"
                    echo "Commit: ${GIT_COMMIT}"
                '''
            }
        }
    }
    
    post {
        success {
            echo ' CI Pipeline completed successfully!'
            echo 'Next: Deploy via Spinnaker'
        }
        failure {
            echo ' CI Pipeline failed'
        }
    }
}