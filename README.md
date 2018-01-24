# Artifactory as Code

### Description
The intention of this project is to create the easily configurable template, summarize the current best thinking and create unification for automatic deploy and configuration of Artifactory Pro.

Use JIRA for authentication

### Getting started
#### Requirements

* Linux host
* Docker 1.11
* Docker Compose 1.8
* Make sure that you are using umask 022 or similar since during the build process configuration files will be copied to the Jenkins container as a root user but Jenkins runs by another user, so we need to make sure that those files are readable for group and others.

* Create "application" in JIRA  >>>>>>

#### Setting it up

* Clone this repository

```
git clone <<change>>
```

* Place the artifactory license file in the "/tmp" folder as "artifactory.lic"
* FILESTORE is set to "/data/artifactory". Change as appropriate.
* Uncomment the below lines towards the end of prepareHostEnv.sh file ONLY when running for first time;

#cleanDataDir
#createDirectories

* Ensure the user who is running this script has sudo priveleges
* Execute ./startup.sh. It would take about 5 mins to download images, bring up the 3 docker containers, connect to JIRA and setup REPOSITORIES.
* Artifactory should be available at "https://<hostname>/".
* curl -v https://<hostname> should resolve certificate and should redirect to "artifactory/webapp"
* Login with admin/password and go to "Admin->Security->Crowd/JIRA"
* Click on the search button (icon) under "Synchronize groups"
* Select "administrators" and click on "Import" (icon) and then "Save". Repeat the same for all other JIRA groups that would need to access Artifactory
* Go to "Groups->administrators", enable the "Admin privileges" checkbox and click "Save"
* Reverse proxy configuration is taken care of by nginx configuration. No additional setup required in Artifactory
* Log out and you should be able to log in with your Demo.com LDAP credentials.
* Create "permissions" to control who can upload to docker-dev and docker-prod repos
* Docker registry names should match the ones defined in nginx

#### Maintenance

To start Artifactory

"sudo docker-compose -f nginx_artifactory.yml up -d"

To stop Artifactory


"sudo docker-compose -f nginx_artifactory.yml down"

To restart a specific service (e.g. nginx)

sudo docker-compose -f nginx_artifactory.yml restart nginx


Ensure that the maintenance timings do not interfere - extra care should be taken that Garbage collection and Backup **do not** happen simultaneously.

### Configuration

>>>Diagram
file [here](dockerizeit/master/README.md)

### Usage

* Docker registry

Two repositories are setup to serve as docker registries;

    Dev registry - art-dev.demo.com
    Production registry - art-prod.demo.com

* Logging

Log in to the registry using your LDAP credentials as below;

$ docker login art-dev.demo.com

Currently only "MS Developers" & "MS Testers" group members are able to login and push images to "art-dev" registry. The "art-prod" registry is restricted to "Administrators". We plan to create separate group for the same.

* Tagging docker images

$ docker tag <image_name>:<tag> art-dev.demo.com/<image_name>:<tag>

Example:

$ docker tag postgres:9.5.7-alpine art-dev.demo.com/postgres:9.5.7-alpine


* Pushing docker images

$ docker push art-dev.demo.com/<image_name>:<tag>

Example:

$ docker push art-dev.demo.com/postgres:9.5.7-alpine


### Roadmap and contributions
