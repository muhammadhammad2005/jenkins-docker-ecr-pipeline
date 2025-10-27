pipeline {
  agent any

  environment {
    AWS_REGION = "ap-south-1"
    ECR_REPO = "221082195621.dkr.ecr.ap-south-1.amazonaws.com/hello-world-app"
    DEPLOY_HOST = "admin@192.168.122.105"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${ECR_REPO}:latest ."
      }
    }

    stage('Login to ECR and Push') {
      environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
      }
      steps {
        sh """
          aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
          docker push ${ECR_REPO}:latest
        """
      }
    }

    stage('Deploy to App Server') {
      steps {
        sshagent(credentials: ['vm-ssh-key']) {
          sh '''
            scp -o StrictHostKeyChecking=no deploy-script.sh $DEPLOY_HOST:/tmp/deploy-script.sh
            ssh -o StrictHostKeyChecking=no $DEPLOY_HOST "chmod +x /tmp/deploy-script.sh && /tmp/deploy-script.sh ${ECR_REPO}:latest"
          '''
        }
      }
    }
  }

  post {
    success {
      echo "✅ Deployment successful!"
    }
    failure {
      echo "❌ Deployment failed."
    }
  }
}
