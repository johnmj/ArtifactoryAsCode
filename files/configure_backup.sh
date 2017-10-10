#!/bin/bash
##############################################################################
# This script configures artifactory backup policies
# It uses the REST api.
# Invoke this script when the REST api is available
# Copyright (c) 2017. Mapscape B.V. All rights reserved
##############################################################################

##############################################################################
# Variables
##############################################################################
ARTIFACTORY_ADMIN_USER_NAME="$1"
ARTIFACTORY_ADMIN_PASSWORD="$2"
ARTIFACTORY_URL="https://localhost/artifactory"

CONFIGFILE_DAILY_BACKUP="$3"
CONFIGFILE_WEEKLY_BACKUP="$4"

##############################################################################
# Functions
##############################################################################
function usage {

echo "Usage: $0 username password daily weekly"
echo "Parameters:"
echo " username       - name of the admin account used to logon to artifactory"
echo " password       - password that is part of the admin account"
echo " daily          - name of the config file used for daily backup"
echo " weekly         - name of the config file used for daily backup"
}


##############################################################################
# Main
##############################################################################
# The required credentials must be passed to this script via arguments
if [[ -z "$4" ]]; then
    echo "Error! Missing arguments.
    echo "This script was invoked as ## $0 $@ ##"
    usage
    exit 1
fi


# TO DO: remove the --insecure option when we can authenticate to artifactory
# with our own security certificate instead of the self-signed one

# Setup for daily and weekly backups
curl -X PUT -u $ARTIFACTORY_ADMIN_USER_NAME:$ARTIFACTORY_ADMIN_PASSWORD $ARTIFACTORY_URL/api/backup/backup-daily -H "Content-Type: application/json" -d "@$CONFIGFILE_DAILY_BACKUP" --insecure
curl -X PUT -u $ARTIFACTORY_ADMIN_USER_NAME:$ARTIFACTORY_ADMIN_PASSWORD $ARTIFACTORY_URL/api/backup/backup-weekly -H "Content-Type: application/json" -d "@$CONFIGFILE_WEEKLY_BACKUP" --insecure

##############################################################################
# End of script
##############################################################################
