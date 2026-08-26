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
                sh 'docker tag curso-devops-backend ghcr.io/athomo001/curso-devops-backend'
                sh 'docker tag curso-devops-backend athomo001/curso-devops-backend'
                
                
            }
        }
        stage('CD - Distribuir DockerHUB'){
            steps{
                script{
                    //autenticacion
                    docker.withRegistry('https://index.docker.io/v1/','curso-devops-dh'){
                    //push
                    sh 'docker push athomo001/curso-devops-backend'  
                    }
                }
            }
        }
        stage('CD - Distribuir Github'){
            steps{
                script{
                    //autenticacion
                    docker.withRegistry('https://ghcr.io','curso-devops-gh'){
                    //push
                    sh 'docker push ghcr.io/athomo001/curso-devops-backend'
                    }
                }
            }
        }
    }
}