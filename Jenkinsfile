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
                stage('CI -version de APP'){
                    steps{
                        script{
                            env.APP_SEMANTIC_VERSION = sh (
                                script: 'npm pkg get version | tr -d \'"\' ',
                                returnStdout: true
                            ).trim()
                            echo "la version es: ${env.APP_SEMANTIC_VERSION}"                            

                        }
                    }
                }
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
        stage('CI - Construir imagen de docker'){
            steps {              
                // Construcción de la imagen Docker etiquetada como latest a partir del Dockerfile en la raíz
                sh 'docker build -t curso-devops-backend:latest .'
                // Se usan comillas dobles para que Groovy interpole la variable de entorno
                sh "docker tag curso-devops-backend ghcr.io/athomo001/curso-devops-backend:${env.APP_SEMANTIC_VERSION}"
                // Se utiliza el usuario correcto 'athanespinoza' de Docker Hub para el tag
                sh "docker tag curso-devops-backend athanespinoza/curso-devops-backend:${env.APP_SEMANTIC_VERSION}"
                
                
            }
        }
        stage('CD - Distribuir DockerHUB'){
            steps{
                script{
                    // Autenticación en Docker Hub utilizando las credenciales configuradas
                    docker.withRegistry('https://index.docker.io/v1/','curso-devops-dh'){
                        // Sube la imagen usando la versión semántica de la aplicación
                        sh "docker push athanespinoza/curso-devops-backend:${env.APP_SEMANTIC_VERSION}"  
                    }
                }
            }
        }
        stage('CD - Distribuir Github'){
            steps{
                script{
                    // Autenticación en GitHub Container Registry
                    docker.withRegistry('https://ghcr.io','curso-devops-gh'){
                        // Sube la imagen a GitHub Packages usando la versión semántica de la aplicación
                        sh "docker push ghcr.io/athomo001/curso-devops-backend:${env.APP_SEMANTIC_VERSION}"
                    }
                }
            }
        }
    }
}