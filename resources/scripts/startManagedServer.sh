#!/bin/bash
#
# Copyright (c) 2019, 2020, Oracle and/or its affiliates.
#
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
#

source /var/opt/oracle/scripts/setEnv.sh

export DOMAIN_HOME=$DOMAIN_ROOT/$DOMAIN_NAME
echo "Domain Home is:  $DOMAIN_HOME"

function getManagedName {
  index=1
  maxIndex=$(($CONFIGURED_MANAGED_SERVER_COUNT + 1))

  while [ $index -lt $maxIndex ]; do
    lockFile="$DOMAIN_HOME/${MANAGED_SERVER_NAME_BASE}$index"
    if test -f "$lockFile"; then
      index=$((index + 1))
    else
      touch $lockFile
      echo "${MANAGED_SERVER_NAME_BASE}$index"
      index=$((maxIndex))
    fi
  done
}

#Pour laisser le temps à l'admin de renseigner son hostname
sleep 1
export ADMIN_HOST=$(cat "${DOMAIN_ROOT}/adminHostName")

# Wait for AdminServer to become available for any subsequent operation
/var/opt/oracle/scripts/waitForAdminServer.sh
export MANAGED_NAME="$(getManagedName)"
export MS_HOME="${DOMAIN_HOME}/servers/${MANAGED_NAME}"
export MS_SECURITY="${MS_HOME}/security"

echo "Managed Server Name: ${MANAGED_NAME}"
echo "Managed Server Home: ${MS_HOME}"
echo "Managed Server Security: ${MS_SECURITY}"

# Create Managed Server
mkdir -p ${MS_SECURITY}
chmod +w ${MS_SECURITY}
echo "Make directory ${MS_SECURITY} to create boot.properties"
echo "username=weblogic" >> ${MS_SECURITY}/boot.properties
echo "password=weblogiC1!" >> ${MS_SECURITY}/boot.properties

#Set Java options
export JAVA_OPTIONS=${JAVA_OPTIONS}
echo "Java Options: ${JAVA_OPTIONS}"

${DOMAIN_HOME}/bin/setDomainEnv.sh
echo "Connecting to Admin Server at http://${ADMIN_HOST}:${ADMIN_LISTEN_PORT}"
${DOMAIN_HOME}/bin/startManagedWebLogic.sh ${MANAGED_NAME} "http://${ADMIN_HOST}:${ADMIN_LISTEN_PORT}"

# tail Managed Server log
touch ${MS_HOME}/logs/${MANAGED_NAME}.log
tail -f ${MS_HOME}/logs/${MANAGED_NAME}.log &

childPID=$!
wait $childPID
