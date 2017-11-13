#!/bin/bash

## Invoke prepareHostEnv script
sudo ./prepareHostEnv.sh -t pro -d /data/artifactory -c -f -l /tmp
## Bring up the containers
sudo docker-compose -f nginx_artifactory.yml up -d --build
echo "Waiting for Artifactory to be initialized....."
sleep 130
ARTIFACTORY_URL="http://localhost:8082/artifactory"
#ARTIFACTORY_URL="http://localhost:8070/artifactory"


##Check if repo already exists??
#### SETUP REPOSITORIES ####
echo "Setting up repositories..."
cd repo-setup
curl -X PUT -H "Content-Type: application/json" -u admin:password "${ARTIFACTORY_URL}/api/repositories/sample-maven-repo" --data @maven-repo.json
curl -X PUT -H "Content-Type: application/json" -u admin:password "${ARTIFACTORY_URL}/api/repositories/conan-dev" --data @conan-repo.json
curl -X PUT -H "Content-Type: application/json" -u admin:password "${ARTIFACTORY_URL}/api/repositories/docker-dev-local" --data @docker-dev-local-repo.json
curl -X PUT -H "Content-Type: application/json" -u admin:password "${ARTIFACTORY_URL}/api/repositories/docker-dev" --data @docker-dev-virtual-repo.json
curl -X PUT -H "Content-Type: application/json" -u admin:password "${ARTIFACTORY_URL}/api/repositories/docker-prod-local" --data @docker-prod-local-repo.json
curl -X PUT -H "Content-Type: application/json" -u admin:password "${ARTIFACTORY_URL}/api/repositories/docker-prod" --data @docker-prod-virtual-repo.json
cd ..
#### SETUP CROWD ####
echo "Setting up CROWD authentication..."
cd user-setup
#curl -u admin:password -v -X PUT -H "Content-Type: application/json" "${ARTIFACTORY_URL}/api/crowd" --data @staging-crowd.json
curl -u admin:password -v -X PUT -H "Content-Type: application/json" "${ARTIFACTORY_URL}/api/crowd" --data @production-crowd.json
cd ..

#### SETUP SMTP ####
echo "Setting up SMTP..."
cd smtp-setup
curl -u admin:password -v -X POST -H "Content-Type: application/json" "${ARTIFACTORY_URL}/api/plugins/execute/setSmtp" --data @staging-smtp.json
cd ..
