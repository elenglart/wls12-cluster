#!/bin/bash

########### SIGTERM handler ############
function _term() {
   echo "Stopping container."
   echo "SIGTERM received, shutting down the server!"
   ${DOMAIN_HOME}/bin/stopWebLogic.sh
}

########### SIGKILL handler ############
function _kill() {
   echo "SIGKILL received, shutting down the server!"
   kill -9 $childPID
}

# Set SIGTERM handler
trap _term SIGTERM

# Set SIGKILL handler
trap _kill SIGKILL

source /var/opt/oracle/scripts/setEnv.sh
echo "Domain Home is:  $DOMAIN_HOME"

#Create the domain the first time
if [ ! -f ${DOMAIN_HOME}/servers/${ADMIN_NAME}/logs/${ADMIN_NAME}.log ]; then
   # Create domain
   wlst.sh -skipWLSModuleScanning /var/opt/oracle/wlst/create-wls-domain.py
   retval=$?

   echo  "RetVal from Domain creation $retval"

   if [ $retval -ne 0 ];
   then
      echo "Domain Creation Failed.. Please check the Domain Logs"
      exit
   fi

   # Create the security file to start the server(s) without the password prompt
   mkdir -p ${DOMAIN_HOME}/servers/${ADMIN_NAME}/security/
   echo "username=weblogic" >> ${DOMAIN_HOME}/servers/${ADMIN_NAME}/security/boot.properties
   echo "password=weblogiC1!" >> ${DOMAIN_HOME}/servers/${ADMIN_NAME}/security/boot.properties
fi

#Set Java options
export JAVA_OPTIONS=${JAVA_OPTIONS}
echo "Java Options: ${JAVA_OPTIONS}"

${DOMAIN_HOME}/bin/setDomainEnv.sh

echo "Starting the Admin Server"
echo "=========================="

# Start Admin Server and tail the logs
${DOMAIN_HOME}/startWebLogic.sh
touch ${DOMAIN_HOME}/servers/${ADMIN_NAME}/logs/${ADMIN_NAME}.log
tail -f ${DOMAIN_HOME}/servers/${ADMIN_NAME}/logs/${ADMIN_NAME}.log &

childPID=$!
wait $childPID


