pipeline {
  agent any
  options {
    timestamps()
  }
  environment {
    IMAGE = 'etl-robot-demo:latest'
  }
  stages {
    stage('Terraform Plan (Azure VM)') {
      when { expression { return fileExists('infra/azure-jenkins') } }
      steps {
        withCredentials([file(credentialsId: 'TFVARS_FILE', variable: 'TFVARS_FILE')]) {
          sh '''
            set -euxo pipefail
            cd infra/azure-jenkins
            terraform init
            terraform plan -var-file="$TFVARS_FILE"
            # Uncomment to provision (costs may apply):
            # terraform apply -auto-approve -var-file="$TFVARS_FILE"
          '''
        }
      }
    }
    stage('Build Docker image') {
      steps {
        sh 'docker version'
        sh 'docker build -t $IMAGE .'
      }
    }
    stage('Run Robot tests') {
      steps {
        sh '''
          set -euxo pipefail
          rm -rf results && mkdir -p results
          docker run --rm \
            -v "$PWD":/work \
            -w /work \
            $IMAGE \
            robot --outputdir /work/results --xunit /work/results/xunit.xml tests/etl_validation.robot
        '''
      }
    }
  }
  post {
    always {
      archiveArtifacts artifacts: 'results/**/*', fingerprint: true, onlyIfSuccessful: false
      junit allowEmptyResults: true, testResults: 'results/xunit.xml'
    }
  }
}