# Artifactory as Code

### Description
The intention of this project is to create the easily configurable template, summarize the current best thinking and create unification for automatic deploy and configuration of Artifactory Pro.

* "Demo.com" is the organisation name used throughout this setup
* This setup uses JIRA for user authentication (This can be changed to LDAP)

#### Requirements

* Create "application" in JIRA  and modify user-setup/crowd.json
Default setting:
```
"applicationName":"artifactory-docker",
"password":"password",
```
#### Setting it up

* Clone this repository

```
git clone <<change>>
```

* Place the artifactory license file in the "/tmp" folder as "artifactory.lic"
* FILESTORE is set to "/data/artifactory". Change as appropriate.
* Uncomment the below lines towards the end of prepareHostEnv.sh file ONLY when running "startup.sh" for a new setup or to overwrite an existing setup;

#cleanDataDir
#createDirectories

* Ensure the user running this script has sudo privileges
* Execute ./startup.sh. This will download images, bring up the 3 docker containers, connect to JIRA and setup repositories.
* Artifactory should now be available at "https://<hostname>/".
* curl -v https://<hostname> should resolve certificate and should redirect to "artifactory/webapp"
* Login with admin/password and go to "Admin->Security->Crowd/JIRA"
* Click on the search button (icon) under "Synchronize groups"
* Select "administrators" and click on "Import" (icon) and then "Save". Repeat the same for all other JIRA groups that would need to access Artifactory
* Go to "Groups->administrators", enable the "Admin privileges" checkbox and click "Save"
* HTTP to HTTPS redirection and reverse proxy configuration is taken care of by nginx configuration. No additional setup required in Artifactory
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

* Postgresql backup >>>

### Detailed overview with docker networking

>>>Diagram


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
