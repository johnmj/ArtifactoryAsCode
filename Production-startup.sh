#!/bin/bash

echo "TBD"
exit 

#sudo ./prepareHostEnv.sh -t pro -d /data1 -c -f -l /tmp
#sudo docker-compose -f nginx_artifactory.yml up -d --build
#echo "Waiting for Artifactory to be initialized....."
#sleep 130
#ARTIFACTORY_URL="http://localhost:8082/artifactory"
#ARTIFACTORY_URL="http://localhost:8082/artifactory"
#ARTIFACTORY_URL="http://localhost:8070/artifactory"


##Check if repo already exists??
#### SETUP REPOSITORIES ####
#echo "Setting up repositories..."
#cd repo-setup
#curl -X PUT -H "Content-Type: application/json" -u admin:password "${ARTIFACTORY_URL}/api/repositories/sample-maven-repo" --data @maven-repo.json
#curl -X PUT -H "Content-Type: application/json" -u admin:password "${ARTIFACTORY_URL}/api/repositories/sample-conan-repo" --data @conan-repo.json
#cd ..
#### SETUP CROWD ####
#echo "Setting up CROWD authentication..."
#cd user-setup
#curl -u admin:password -v -X PUT -H "Content-Type: application/json" "${ARTIFACTORY_URL}/api/crowd" --data @staging-crowd.json
#cd ..

#### SETUP SMPT ####
#echo "Setting up SMTP..."
#cd smtp-setup
#curl -u admin:password -v -X POST -H "Content-Type: application/json" "${ARTIFACTORY_URL}/api/plugins/execute/setSmtp" --data @staging-smtp.json
#cd ..
