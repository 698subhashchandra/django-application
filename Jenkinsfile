@Library('Shared') _
pipeline {
    agent any

    environment {
        SONAR_HOME = tool "Sonar"
        GIT_REPO_URL = "https://github.com/698subhashchandra/django-application.git"
        GIT_BRANCH = "main"
        DOCKER_USER = "698subhashchandra"
        /*BACKEND_IMAGE = "wanderlust-backend-beta"*/
        FRONTEND_IMAGE = "django-application-frontend"
    }

    parameters {
        string(name: 'FRONTEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
        /*string(name: 'BACKEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')*/
    }

    stages {
        stage("Validate Parameters") {
            steps {
                script {
                     if (params.FRONTEND_DOCKER_TAG == '') {
                        error("FRONTEND_DOCKER_TAG.")
                    }
                }
            }
        }

        stage("Workspace cleanup") {
            steps {
                script {
                    cleanWs()
                }
            }
        }

        stage('Git: Code Checkout') {
            steps {
                script {
                    code_checkout("${env.GIT_REPO_URL}", "${env.GIT_BRANCH}")
                }
            }
        }

        stage("Trivy: Filesystem scan") {
            steps {
                script {
                    trivy_scan()
                }
            }
        }

        stage("OWASP: Dependency check") {
            steps {
                script {
                    owasp_dependency()
                }
            }
        }

        stage("SonarQube: Code Analysis") {
            steps {
                script {
                    sonarqube_analysis("${env.SONAR_HOME}", "django-application", "django-application")
                }
            }
        }

        stage("SonarQube: Code Quality Gates") {
            steps {
                script {
                    sonarqube_code_quality()
                }
            }
        }

        stage('Exporting environment variables') {
            parallel {
                /*stage("Backend env setup") {
                    steps {
                        script {
                            dir("Automations") {
                                sh "bash updatebackendnew.sh"
                            }
                        }
                    }
                }*/

                stage("Frontend env setup") {
                    steps {
                        script {
                            dir("Automations") {
                                sh "bash updatefrontendnew.sh"
                            }
                        }
                    }
                }
            }
        }

        stage("Docker: Build Images") {
            steps {
                script {
                    /*dir('backend') {
                        docker_build("${env.BACKEND_IMAGE}", "${params.BACKEND_DOCKER_TAG}", "${env.DOCKER_USER}")
                    }*/

                    dir('frontend') {
                        docker_build("${env.FRONTEND_IMAGE}", "${params.FRONTEND_DOCKER_TAG}", "${env.DOCKER_USER}")
                    }
                }
            }
        }

        stage("Docker: Push to DockerHub") {
            steps {
                script {
                    /*docker_push("${env.BACKEND_IMAGE}", "${params.BACKEND_DOCKER_TAG}", "${env.DOCKER_USER}")*/
                    docker_push("${env.FRONTEND_IMAGE}", "${params.FRONTEND_DOCKER_TAG}", "${env.DOCKER_USER}")
                }
            }
        }
    }


}