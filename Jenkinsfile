// Función auxiliar para resumir la lógica de etiquetado y publicación de imágenes Docker
def tagAndPush(String localImage, String repo, String registry, String credential) {
    docker.withRegistry(registry, credential) {
        // Genera las etiquetas correspondientes: latest, número de build y versión semántica
        sh "docker tag ${localImage} ${repo}:latest"
        sh "docker tag ${localImage} ${repo}:${env.BUILD_NUMBER}"
        sh "docker tag ${localImage} ${repo}:${env.APP_SEMANTIC_VERSION}"
        
        // Sube las imágenes etiquetadas al registro correspondiente
        sh "docker push ${repo}:latest"
        sh "docker push ${repo}:${env.BUILD_NUMBER}"
        sh "docker push ${repo}:${env.APP_SEMANTIC_VERSION}"
    }
}

pipeline {
    agent any

    // Variables de entorno para parametrizar el pipeline, adaptadas al entorno del alumno
    environment {
        IMAGE_NAME     = "curso-devops-backend"
        DH_REPO        = "athanespinoza/curso-devops-backend"
        GHCR_REPO      = "ghcr.io/athomo001/curso-devops-backend"
        K8S_NAMESPACE  = "curso-devops"
        K8S_DEPLOYMENT = "curso-devops-deployment"
        K8S_CONTAINER  = "contenedor-curso-devops"
    }
  
    stages {
        stage('CI - integracion continua'){ 
            agent {
                docker {
                    image "node:24"
                    reuseNode true
                }
            }
            stages {
                stage('CI -version de APP'){
                    steps {
                        script {
                            // Extrae la versión semántica desde el package.json
                            env.APP_SEMANTIC_VERSION = sh (
                                script: 'npm pkg get version | tr -d \'"\' ',
                                returnStdout: true
                            ).trim()
                            echo "La versión de la aplicación es: ${env.APP_SEMANTIC_VERSION}"                            
                        }
                    }
                }
                stage('CI - instalar dependencias') {
                    steps {
                        sh 'npm install'
                    }
                }
                stage('CI - Ejecutar lint'){
                    steps {
                        sh 'npm run lint'
                    }
                }
                stage('CI - Ejecutar test'){
                    steps {
                        sh 'npm test'
                    }
                }
                stage('CI - construir build'){
                    steps {
                        sh 'npm run build'
                    }
                }
            }
        }
        
        // Etapa de análisis estático de código con SonarQube
        stage('Quality Assurance'){
            agent {
                docker {
                    image 'sonarsource/sonar-scanner-cli'
                    args '--network devops-infra_default'
                    reuseNode true
                }
            }
            stages {
                stage('validacion de codigo'){
                    steps {
                        // Inyecta la credencial 'jenkins-token' como variable de entorno para la autenticación de SonarQube
                        withCredentials([string(credentialsId: 'jenkins-token', variable: 'SONAR_TOKEN')]) {
                            withSonarQubeEnv('sonarqube'){
                                sh 'sonar-scanner'
                            }
                        }
                    }
                }
                stage('Validacion de puerta de calidad'){
                    options {
                        timeout(time: 1, unit: "MINUTES")
                    }
                    steps {
                        script {
                            // Espera a que el servidor de SonarQube responda con el estado del análisis
                            def qualityGate = waitForQualityGate(); 
                            if(qualityGate.status != 'OK'){
                                error "La puerta de calidad ha fallado: ${qualityGate.status}"
                            }
                        }
                    }
                }
            }
        }

        stage('CI - Construir imagen de docker'){
            steps {              
                // Compila la imagen Docker local
                sh "docker build -t ${env.IMAGE_NAME}:latest ."
            }
        }

        stage('CD - Distribuir DockerHUB'){
            steps {
                script {
                    // Invoca la función auxiliar para tagear y hacer push en Docker Hub
                    tagAndPush(env.IMAGE_NAME, env.DH_REPO, 'https://index.docker.io/v1/', 'curso-devops-dh')
                }
            }
        }

        stage('CD - Distribuir Github'){
            steps {
                script {
                    // Invoca la función auxiliar para tagear y hacer push en GitHub Container Registry
                    tagAndPush(env.IMAGE_NAME, env.GHCR_REPO, 'https://ghcr.io', 'curso-devops-gh')
                }
            }
        }
    }
}