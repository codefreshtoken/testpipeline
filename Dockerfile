FROM ubuntu:18.04

WORKDIR /app
COPY credentials /app

#install mysql client
RUN apt-get update \
    && apt-get install -y --no-install-recommends mysql-client \
    && rm -rf /var/lib/apt/lists/*

#install gcloud pre-requisites
RUN apt-get update && apt-get install -y curl
RUN apt-get update && apt-get install -y python-pip
RUN apt-get update && apt-get install -y python
RUN apt-get update && apt-get install -y python3.6

# Downloading gcloud package
RUN curl -L https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the gcloud package
RUN mkdir -p /usr/local/gcloud \
    && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
    && /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Add gcloud authentication
RUN gcloud auth activate-service-account --key-file=./dockerbuildusersakey.json
RUN gcloud config set project circlesmarket-wip-231711
RUN gcloud components install docker-credential-gcr --quiet
RUN gcloud auth configure-docker --quiet