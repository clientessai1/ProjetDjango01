pipeline {
    //agent any
    agent { label('ubuntu-dev-agent') }

    environment {
      container_1 = "my-pipeline-1_web_1"
    }

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
				docker-compose down --rmi all 
                #docker container stop $container_1 && \
                #docker container rm $container_1
                echo "Container deleted !!!"
                fi
                ''';

                sh '''
                if [ -z "$(docker ps -q -f name=$container_1)" ]; then
                echo "Container n'existe PAS !!!"
				docker-compose up --build -d
                fi
                ''';


            }
        }

		stage('Run Tests'){

		   steps{
		     //Run django tests
			 sh '''
			   if [ "$(docker ps -q -f name=$container_1)" ]; then
			     echo "Container exist. So let's run some tests !!!";
				 docker exec -i $container_1 python manage.py test
			   fi
			 ''';

			 sh '''
			   if [ -z "$(docker ps -q -f name=$container_1)" ]; then
			     echo "Container does not exist !!!";
			   fi
			 ''';

		   }

		}


    }
}
