pipeline {
  agent any
  stages {
    stage('Git pull') {
      steps {
        sh 'echo git pull'
      }
    }

    stage('Docker Build') {
      steps {
        sh '''echo docker build .
echo docker push'''
      }
    }

    stage('Testing') {
      parallel {
        stage('Linux Testing') {
          steps {
            sh 'echo Linux Testing'
          }
        }

        stage('windows Testing') {
          steps {
            sh 'echo Windows Testing'
          }
        }

      }
    }

    stage('Deploy') {
      steps {
        sh 'echo Deploy'
      }
    }

  }
}