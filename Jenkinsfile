pipeline{
    agent any
    stage('CI - integracion continua'){
    
        steps{
 
        agent {
            docker {
                image "node:24"
                reuseNode true
            }
        }

        stages {
        stage('CI - Instalar dependencias'){
            steps{
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
    stage('CD - Distribucion'){
        agent 
        stage('CD - contruir  imagen docker'){
            steps{
                sh 'docker build-t curso-devops-backend:latest .'
            }

        }
    }
}