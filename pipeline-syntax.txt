node{
    stage('git pull'){
        git 'https://github.com/shivapoudyal/java-project.git'
    }

    stage('Mvn Package'){
        
        def mvnHome = tool name: 'maven', type: 'maven'
        def mvnCmd = "${mvnHome}/bin/mvn"
        sh "${mvnCmd} clean package"
    }

    stage('Build Docker Image'){

        sh 'docker build -t shivapoudyal/java-project:3.0 .'
    }

    stage('Login & Push Image to Docker Hub'){

        withCredentials([string(credentialsId: 'docker-hub-pass', variable: 'dockerHubPass')]) {
            sh "docker login -u shivapoudyal -p ${dockerHubPass}"
        }

        sh 'docker push shivapoudyal/java-project'
    }

    stage('Run Container on staging-server'){

        def dockerRun = 'sudo docker run -p 8070:8080 -d --name my-java-project shivapoudyal/java-project:3.0'

        sshagent(['web-server-credentails']) {
           sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.28.138 ${dockerRun} "
        }


    }
}
