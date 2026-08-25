pipeline{
    agent any    
    stages{
        stage('CI - integracion continua'){ 
            agent{
                docker{
                    image "node:24"
                    reuseNode true
                }
            }
            stages {
                stage('CI - instalar ependencias') {
                    steps {
                        sh 'npm install'
                    }
                }
                stage('CI - Ejecutar lint'){
                    steps{
                        sh 'npm run lint'
                    }
                }
                stage('CI - Ejecutar test'){
                    steps{
                        sh 'npm test'
                    }
                }
                stage('CI - construir build'){
                    steps{
                        sh 'npm run build'
                    }
                }
                
            }
        }
    }
    stage('CI - Distribuir imagen de docker'){
        steps {
            sh 'docker build -t curso-devops-backend:latest .'
        }
    }
}