FROM python:3.8
#FROM python:3.8-slim-buster

# Setting work directory.
WORKDIR /usr/src/app

# env variables
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# Install dependencies
RUN pip install --upgrade pip pipenv flake8
#RUN pip install pip pipenv flake8
COPY ./dj_docker01 .
# run this command to install all dependencies  
RUN pip install -r requirements.txt  pylint
#COPY Pipfile* ./
#COPY Pipfile Pipfile.lock ./
#RUN pipenv install --system --ignore-pipfile


# link, We run flake8 to see later suggestions
#RUN flake8 --ignore=E501,F401 .
