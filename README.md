# Artifactory as Code

### Description
The intention of this project is to automate the dockerized deployment and configuration of Artifactory Pro using Nginx as the proxy and Postgres as the database.

* This project has been tested **only** for ARTIFACTORY PRO but can be extended to HA
* "Demo.com" is the organisation name and "demo-artifactory" is the docker host used throughout this setup
* This setup uses JIRA for user authentication (This can be changed to LDAP)

#### Pre-requisites

* Artifactory Pro license
* Valid domain SSL certificates


#### Setting it up

* Create a new "application" in JIRA user server and provide the hostname as "demo-artifactory".

* Modify "user-setup/jira.json" with the appropriate values;

Default setting:
```
"applicationName":"artifactory-docker",
"password":"password",
```
* If LDAP is used for authentication, modify the "user-setup/jira.json" and add relevant API call in "startup.sh"

* Clone this repository on the docker host;

```
git clone https://github.com/johnmj/ArtifactoryAsCode.git
```

* Place the Artifactory Pro license file as "artifactory.lic" in the "/tmp" folder of "demo-artifactory". The setup will still continue even if no license file is specified and can be manually added later.
* Replace the "nginx/demo.key" and "nginx/demo.pem" files with valid SSL certificates from your organisation.
* FILESTORE is set to "/data/artifactory" in "startup.sh". 
* Uncomment the below lines towards the end of "prepareHostEnv.sh" file ONLY when running "startup.sh" for a new setup or to overwrite an existing setup;
```
#cleanDataDir
#createDirectories
```

* Ensure the user running this script has sudo privileges on the docker host
* Execute ./startup.sh. This will download images, bring up the 3 docker containers, connect to JIRA and setup repositories.
* Artifactory should now be available at "https://demo-artifactory/".
* curl -v https://demo-artifactory/ should resolve SSL certificate and automatically redirect to "https://demo-artifactory/artifactory/webapp"
* Login with "admin/password" and go to "Admin->Security->Crowd/JIRA"
* Click on the search button (icon) under "Synchronize groups". If Artifactory is unable to authenticate agains JIRA then check the settings of JIRA application created earlier (Default: artifactory-docker)
* Select "administrators" and click on "Import" (icon) and then "Save". Repeat the same for all other JIRA groups that would need to access Artifactory.
* Go to "Groups->administrators", enable the "Admin privileges" checkbox and click "Save"
* HTTP to HTTPS redirection and reverse proxy configuration is taken care of by nginx configuration. No additional setup required in Artifactory
* Log out and you should be able to log in with your Demo.com JIRA/LDAP credentials.
* Create "permissions" to control who can upload to docker-dev and docker-prod repos
* Docker registry names should match the ones defined in nginx. New docker repositories should have corresponding entries in "nginx/conf.d/artifactory.conf" as all forwarding is done via nginx.
* No additional reverse proxy configurations are needed in Artifactory

#### Maintenance

To start Artifactory

"sudo docker-compose -f nginx_artifactory.yml up -d"

To stop Artifactory

"sudo docker-compose -f nginx_artifactory.yml down"

To restart a specific service (e.g. nginx)

sudo docker-compose -f nginx_artifactory.yml restart nginx


Ensure that the maintenance timings do not interfere - extra care should be taken that Garbage collection and Backup **do not** happen simultaneously.

* Artifactory backups would be in "/data/artifactory/artifactory/backup" folder
* Postgresql backup : pg_dump artifactory > /volume/postgresql/backup/bkup_postgresql.sql

It is recommended that the above locations are backed up by IT

### Detailed overview with docker networking

[[https://github.com/johnmj/ArtifactoryAsCode/blob/master/Gen_Artifactory_Docker_setup.png|alt=Artifactory_Docker_setup]]


* Postgresql database is on ScaleIO (fast) disk while the FILESTORE is in NFS mount.

[Not covered here]
* Monitoring: Prometheus running as docker container is configured to scrap all container endpoints as well as the host node exporter.
* Grafana alerts are configured to notify on Slack channel.



### Usage

* Docker registry

Two repositories are setup to serve as docker registries;

    Dev registry - art-dev.demo.com
    Production registry - art-prod.demo.com

* Logging in

Log in to the registry using your JIRA/LDAP credentials as below;

$ docker login art-dev.demo.com

_Access control can be configured to ensure only certain groups are able to push images to certain registries._

* Tagging docker images

$ docker tag <image_name>:<tag> art-dev.demo.com/<image_name>:<tag>

Example:

$ docker tag postgres:9.5.7-alpine art-dev.demo.com/postgres:9.5.7-alpine


* Pushing docker images

$ docker push art-dev.demo.com/<image_name>:<tag>

Example:

$ docker push art-dev.demo.com/postgres:9.5.7-alpine
