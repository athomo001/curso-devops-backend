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
        // Stage para la construcción y distribución de la imagen de Docker del backend
        stage('CI - Distribuir imagen de docker'){
            steps {
                // Construcción de la imagen Docker etiquetada como latest a partir del Dockerfile en la raíz
                sh 'docker build -t curso-devops-backend:latest .'
            }
        }
    }
}