FROM store/oracle/weblogic:12.2.1.4-dev

ENV DOMAIN_ROOT="/var/opt/oracle/domains" \
    CLUSTER_TYPE="${CLUSTER_TYPE:-DYNAMIC}" \
    PROPERTIES_FILE_DIR="/var/opt/oracle/properties" \
    JAVA_OPTIONS="-Doracle.jdbc.fanEnabled=false -Dweblogic.StdoutDebugEnabled=false"  \
    PATH="$PATH:${JAVA_HOME}/bin:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin:/u01/oracle/container-scripts"

COPY --chown=oracle:oracle resources/scripts/* /var/opt/oracle/scripts/
USER root
RUN mkdir -p $DOMAIN_ROOT && \
    chown -R root:root $DOMAIN_ROOT/.. && \
    chmod -R a+xwr $DOMAIN_ROOT/.. && \
    chmod +x /var/opt/oracle/scripts/*

USER oracle
WORKDIR $ORACLE_HOME

CMD ["/bin/bash", "/var/opt/oracle/scripts/createWLSDomain.sh"]