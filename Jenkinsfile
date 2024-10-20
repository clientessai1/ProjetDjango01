pipeline {
    agent any

    stages {

        stage('Hello') {
            steps {
                echo 'Hello World V3'
		sh 'pwd'
		sh 'ls ..'
		sh 'ls .'
                sh 'cat /etc/os-release'
            }
        }

        stage('Check docker') {
            steps {
                sh 'docker ps';
//				sh """
//				if [ "$(docker ps -q -f name=procject_files_web_1)" ]; then
//				echo "Container existe !!!"
//				fi
//				""";

                sh '''
                if [ "$(docker ps -q -f name=$container_1)" ]; then
                echo "Container existe !!!"
                docker container stop $container_1 && \
                docker container rm $container_1
                echo "Container deleted !!!"
                fi
                ''';

                sh '''
                if [ "$( ! docker ps -q -f name=$container_1)" ]; then
                echo "Container n'existe PAS !!!"
				docker-compose up --build -d
                fi
                ''';


            }
        }


    }
}
