pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1' 
    }
    tools {
        jfrog 'Jfrog_CLI' // Ensuring JFrog CLI is available
    }

     // JFrog Artifactory Integration
        stage('JFrog Testing') {
            steps {
                script {
                    jf '-v' // Check JFrog CLI version
                    jf 'c show' // Show JFrog configurations
                    jf 'rt ping' // Ping Artifactory
                    sh 'touch test-file' // Create a test file
                    jf 'rt u test-file Jfrog_cli/' // Upload test file to Artifactory
                    jf 'rt bp' // Build publish
                    jf 'rt dl Jfrog_cli/test-file' // Download test file
                }
            }
        }
    }
    post {
        success {
            echo 'Terraform and JFrog operations completed successfully!'
        }
        failure {
            echo 'Pipeline execution failed!'
        }
    }

    // Terraform Integration
    stages {
        stage('Set AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws' 
                ]]) {
                    sh '''
                    echo "AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID"
                    aws sts get-caller-identity
                    '''
                }
            }
        }
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/alacritor/AWS-s3-a_la_carte' 
            }
        }
        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Plan Terraform') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws'
                ]]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform plan -out=tfplan
                    '''
                }
            }
        }
        stage('Apply Terraform') {
            steps {
                input message: "Approve Terraform Apply?", ok: "Deploy"
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws'
                ]]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform apply -auto-approve tfplan
                    '''
                }
            }
        }
    }     
       

// Old Pipeline Jenkins File Fossil

// pipeline {
//     agent any
//     environment {
//         AWS_REGION = 'us-east-1' 
//     }
//     stages {
//         stage('Set AWS Credentials') {
//             steps {
//                 withCredentials([[
//                     $class: 'AmazonWebServicesCredentialsBinding',
//                     credentialsId: 'aws' 
//                 ]]) {
//                     sh '''
//                     echo "AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID"
//                     aws sts get-caller-identity
//                     '''
//                 }
//             }
//         }
//         stage('Checkout Code') {
//             steps {
//                 git branch: 'main', url: 'https://github.com/alacritor/AWS-s3-a_la_carte' 
//             }
//         }
//         stage('Initialize Terraform') {
//             steps {
//                 sh '''
//                 terraform init
//                 '''
//             }
//         }
//         stage('Plan Terraform') {
//             steps {
//                 withCredentials([[
//                     $class: 'AmazonWebServicesCredentialsBinding',
//                     credentialsId: 'aws'
//                 ]]) {
//                     sh '''
//                     export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
//                     export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
//                     terraform plan -out=tfplan
//                     '''
//                 }
//             }
//         }
//         stage('Apply Terraform') {
//             steps {
//                 input message: "Approve Terraform Apply?", ok: "Deploy"
//                 withCredentials([[
//                     $class: 'AmazonWebServicesCredentialsBinding',
//                     credentialsId: 'aws'
//                 ]]) {
//                     sh '''
//                     export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
//                     export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
//                     terraform apply -auto-approve tfplan
//                     '''
//                 }
//             }
//         }
//     }
//     post {
//         success {
//             echo 'Terraform deployment completed successfully!'
//         }
//         failure {
//             echo 'Terraform deployment failed!'
//         }
//     }
// }