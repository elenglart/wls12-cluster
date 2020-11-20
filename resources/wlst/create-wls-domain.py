import os
import socket

domain_name                   = os.environ.get("DOMAIN_NAME")
admin_server_name             = os.environ.get("ADMIN_NAME")
admin_port                    = int(os.environ.get("ADMIN_LISTEN_PORT"))
server_port                   = int(os.environ.get("MANAGED_SERVER_PORT"))
managed_server_name_base      = os.environ.get("MANAGED_SERVER_NAME_BASE")
number_of_ms                  = int(os.environ.get("CONFIGURED_MANAGED_SERVER_COUNT"))
domain_path                   = os.environ.get("DOMAIN_HOME")
cluster_name                  = os.environ.get("CLUSTER_NAME")
production_mode               = os.environ.get("PRODUCTION_MODE")
cluster_address               = os.environ.get("CLUSTER_ADDRESS")

print('domain_path              : [%s]' % domain_path);
print('domain_name              : [%s]' % domain_name);
print('admin_server_name        : [%s]' % admin_server_name);
print('admin_port               : [%s]' % admin_port);
print('cluster_name             : [%s]' % cluster_name);
print('server_port              : [%s]' % server_port);
print('number_of_ms             : [%s]' % number_of_ms);
print('managed_server_name_base : [%s]' % managed_server_name_base);
print('production_mode          : [%s]' % production_mode);

# Open default domain template
# ============================
readTemplate("/u01/oracle/wlserver/common/templates/wls/wls.jar")

set('Name', domain_name)
setOption('DomainName', domain_name)
create(domain_name,'Log')
cd('/Log/%s' % domain_name);
set('FileName', '%s.log' % (domain_name))

# Configure the Administration Server
# ===================================
cd('/Servers/AdminServer')
set('ListenPort', admin_port)
set('Name', admin_server_name)


# Set the admin user's username and password
# ==========================================
cd('/Security/%s/User/weblogic' % domain_name)
cmo.setName('weblogic')
cmo.setPassword('weblogiC1!')

# Write the domain and close the domain template
# ==============================================
setOption('OverwriteDomain', 'true')


# Create a cluster
# ================
cd('/')
cl=create(cluster_name, 'Cluster')
cl.setClusterAddress(cluster_address)
print('Configuring Dynamic Cluster %s' % cluster_name)

templateName = cluster_name + "-template"
print('Creating Server Template: %s' % templateName)
st1=create(templateName, 'ServerTemplate')
print('Done creating Server Template: %s' % templateName)
cd('/ServerTemplates/%s' % templateName)
cmo.setListenPort(server_port)
cmo.setCluster(cl)

channelName = 'external-channel'
nap=create(channelName, 'NetworkAccessPoint')
cd('NetworkAccessPoints/%s' % channelName)
nap.setListenPort(-1)
nap.setPublicPort(-1)
nap.setPublicAddress('localhost')

cd('/Clusters/%s' % cluster_name)
create(cluster_name, 'DynamicServers')
cd('DynamicServers/%s' % cluster_name)
set('ServerTemplate', st1)
set('ServerNamePrefix', managed_server_name_base)
set('DynamicClusterSize', number_of_ms)
set('MaxDynamicClusterSize', number_of_ms)
set('CalculatedListenPorts', false)

print('Done setting attributes for Dynamic Cluster: %s' % cluster_name);

# Write Domain
# ============
writeDomain(domain_path)
closeTemplate()
print 'Domain Created'

# Update Domain
readDomain(domain_path)
cd('/')
setOption('ServerStartMode',production_mode)

updateDomain()
closeDomain()
print 'Domain Updated'
print 'Done'

# Exit WLST
# =========
exit()
