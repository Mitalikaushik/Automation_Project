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

    stage('Linux Testing') {
      parallel {
        stage('Linux Testing') {
          steps {
            sh 'Linux Testing'
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