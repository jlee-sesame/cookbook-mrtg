default['mrtg']['conf_dir'] = '/etc/mrtg'
default['mrtg']['enable_ssl'] = true
default['mrtg']['server_name'] = node.has_key?(:domain) ? "mrtg.#{domain}" : 'mrtg'
default['mrtg']['ssl_cert_file'] = "#{node['mrtg']['conf_dir']}/mrtg.pem"
default['mrtg']['ssl_cert_key']  = "#{node['mrtg']['conf_dir']}/mrtg.pem"
default['mrtg']['ssl_req'] = '/C=US/ST=Several/L=Locality/O=Example/OU=Operations/' +
  "CN=#{node['mrtg']['server_name']}/emailAddress=ops@#{node['mrtg']['server_name']}"
default['mrtg']['http_port']  = node['nagios']['enable_ssl'] ? '443' : '80'
default['mrtg']['sysadmin_email']          = "root@localhost"
default['mrtg']['docroot']    = '/var/www/mrtg'
default['mrtg']['log_dir']    = '/var/log/mrtg'
default['mrtg']['users_databag_group']    = 'sysadmin'
