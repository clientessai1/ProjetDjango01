pipeline {
    agent any

    stages {

        stage('Hello') {
            steps {
                echo 'Hello World V2'
		sh 'pwd'
		sh 'ls ..'
		sh 'ls .'
                sh 'cat /etc/os-release'
            }
        }

        stage('Check docker') {
            steps {
                sh 'docker ps';
				sh """
				if [ "$(docker ps -q -f name=procject_files_web_1)" ]; then
				echo "Container existe !!!"
				fi
				""";
            }
        }


    }
}
