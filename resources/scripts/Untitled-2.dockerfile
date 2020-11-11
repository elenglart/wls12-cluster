DOMAIN_ROOT="/u01/oracle/user_projects/domains" \
    ADMIN_HOST="${ADMIN_HOST:-AdminContainer}" \
    MANAGED_SERVER_PORT="${MANAGED_SERVER_PORT:-8001}" \
    MANAGED_SERVER_NAME_BASE="${MANAGED_SERVER_NAME_BASE:-MS}" \
    MANAGED_SERVER_CONTAINER="${MANAGED_SERVER_CONTAINER:-false}" \
    CONFIGURED_MANAGED_SERVER_COUNT="${CONFIGURED_MANAGED_SERVER_COUNT:-2}" \
    #MANAGED_NAME="${MANAGED_NAME:-MS1}" \
    CLUSTER_NAME="${CLUSTER_NAME:-cluster1}" \
    CLUSTER_TYPE="${CLUSTER_TYPE:-DYNAMIC}" \
    PROPERTIES_FILE_DIR="/u01/oracle/properties" \
    JAVA_OPTIONS="-Doracle.jdbc.fanEnabled=false -Dweblogic.StdoutDebugEnabled=false"  \
    PATH="$PATH:${JAVA_HOME}/bin:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin:/u01/oracle/container-scripts"
