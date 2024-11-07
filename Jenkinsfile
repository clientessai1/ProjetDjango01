pipeline {
    //agent any
    agent { label('ubuntu-dev-agent') }

    environment {
      container_1 = "docker-for-ci_web_1";
      app_folder = "dj_docker01/dj_docker01"; //In initial django project, it is the app folder in the same directory as manage.py file. And both are in the project directory.
      app_folder_in_container = "dj_docker01"; //In container context, as we define the project_folder as the defaut entrance point, so we fall directly in the same directory as the app_folder;
	  fail_under_value = 7; //Under this value the code scan is allowed to fail;
	  ci_reports_dir = "reports/ci-reports";
	  docker_forci_dir = "docker-for-ci";
	  docker_forhub_dir = "docker-for-hub";
      container_2 = "docker-for-hub_web_1";
	  web_app_link = "http://localhost:8000";
	  docker_image = "aristidesama2/django_app01";
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
				cd "$docker_forci_dir" && docker-compose down --rmi all 
                #docker container stop $container_1 && \
                #docker container rm $container_1
                echo "Container deleted !!!"
                fi
                ''';

                sh '''
                if [ -z "$(docker ps -q -f name=$container_1)" ]; then
                echo "Container n'existe PAS !!!"
				cd "$docker_forci_dir" && docker-compose up --build -d && pwd
                fi
                ''';

				sh 'pwd';


            }
        }

		stage('Run Migrations'){
		  steps{
		    //Apply database migrations
			sh '''
			  if [ "$(docker ps -q -f name=$container_1)" ]; then
			    echo "Container exists. So let's run some Migrations !!!";
				docker exec -i $container_1 python manage.py migrate
				else
				echo "Container does not exist. So there is no Migrations !!!";
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
				 else
			     echo "Container does not exist. No test !!!";
			   fi
			 ''';
		   }
		}

		stage('Run Code Scan'){

		  steps{
		    //Run pylint on codebase
			sh '''
			  app_folder_path="$app_folder_in_container/";
			  mkdir -p "$ci_reports_dir"
			  docker exec -i $container_1 pylint --fail-under=$fail_under_value --output-format=text "$app_folder_path" > "$ci_reports_dir/pylint_results.txt"
			''';
		  }
		}

		stage('Create Docker to hub files'){
		  steps{
		    //Create container to hub files from docker-for-ci directory
		    sh'''
			  if [ -d "$docker_forhub_dir" ]; then
				echo "The $docker_forhub_dir folder exists."
				rm -rf "$docker_forhub_dir" #delete and remake to copy
				echo "The $docker_forhub_dir folder is removed."
			  fi
			  cp -rp "$docker_forci_dir" "$docker_forhub_dir" 
			  sed -i 's/pylint//g' "$docker_forhub_dir/Dockerfile"
			  sed -i "s/$docker_forci_dir/$docker_forhub_dir/g" "$docker_forhub_dir/docker-compose.yml"
			  ls .
			''';
		  }
		}

		stage('Destroy testing container and Create docker hub container'){
		  steps{
		    //Check if docker-hub directory exists
			sh'''
			  if [ -d "$docker_forhub_dir" ]; then

			    if [ "$(docker ps -q -f name=$container_1)" ]; then
				  echo "Container $container_1 existe !!!"
				  cd "$docker_forci_dir" && docker-compose down --rmi all 
				fi

			    if [ -z "$(docker ps -q -f name=$container_1)" ]; then
				  echo "Container $container_1 n'existe plus !!!"
				  cd .. && cd "$docker_forhub_dir" && docker-compose up --build -d && pwd // To keep
				  cd "$docker_forhub_dir" && docker-compose down --rmi all && pwd // to be removed later. Just for testing purpose
				fi

			    if [ "$(docker ps -q -f name=$container_2)" ]; then
				  echo "Container $container_2 existe !!!. The next step is sending it to Docker-Hub"
				fi

			  fi
			''';
		  }
		}

		stage('Check web app status'){
		  steps{
		    //Check if the container for docker-hub exists
			script{
			  def status = sh(script: "docker ps -q -f name=${container_2}", returnStdout: true).trim();
			  if(status){
			    echo "Container '${container_2}' is running."
				sh '''
				  response=$(curl -o /dev/null -s -w '%{http_code}' "$web_app_link")
				  if [ "$response" -eq 200 ]; then
				    echo 'Web App is Up !'
				  else
				    echo "Web App is down ! HTTP response code: $response"
					exit 1
				  fi
				''';
			  }else{
			    error "Container '${container_2}' is not running."
			  }
			}

		  }
		}


        stage("Push image to Docker Hub"){
            steps{
                withCredentials([usernamePassword(credentialsId: 'DOCKER_CREDS_ARIS', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]){
                    sh """
                    docker login  --username $USERNAME --password $PASSWORD && docker push $docker_image:latest
                    """
                }
            }
        }


    }
}
