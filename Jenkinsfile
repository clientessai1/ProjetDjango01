pipeline {
    //agent any
    agent { label('ubuntu-dev-agent') }

    environment {
      container_1 = "my-pipeline-1_web_1";
      app_folder = "dj_docker01/dj_docker01"; //In initial django project, it is the app folder in the same directory as manage.py file. And both are in the project directory.
      app_folder_in_container = "dj_docker01"; //In container context, as we define the project_folder as the defaut entrance point, so we fall directly in the same directory as the app_folder;
	  fail_under_value = 7; //Under this value the code scan is allowed to fail;
	  ci_reports_dir = "reports/ci-reports";
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
//
//                sh '''
//                if [ -z "$(docker ps -q -f name=$container_1)" ]; then
//                echo "Container n'existe PAS !!!"
//				docker-compose up --build -d
//                fi
//                ''';


            }
        }

//		stage('Run Migrations'){
//		  steps{
//		    //Apply database migrations
//			sh '''
//			  if [ "$(docker ps -q -f name=$container_1)" ]; then
//			    echo "Container exists. So let's run some Migrations !!!";
//				docker exec -i $container_1 python manage.py migrate
//				else
//				echo "Container does not exist. So there is no Migrations !!!";
//			  fi
//			''';
//		  }
//		}
//
//		stage('Run Tests'){
//
//		   steps{
//		     //Run django tests
//			 sh '''
//			   if [ "$(docker ps -q -f name=$container_1)" ]; then
//			     echo "Container exist. So let's run some tests !!!";
//				 docker exec -i $container_1 python manage.py test
//				 else
//			     echo "Container does not exist. No test !!!";
//			   fi
//			 ''';
//		   }
//		}
//
//		stage('Run Code Scan'){
//
//		  steps{
//		    //Run pylint on codebase
//			sh '''
//			  app_folder_path="$app_folder_in_container/";
//			  mkdir -p "$ci_reports_dir"
//			  docker exec -i $container_1 pylint --fail-under=$fail_under_value --output-format=text "$app_folder_path" > "$ci_reports_dir/pylint_results.txt"
//			''';
//		  }
//		}


    }
}
