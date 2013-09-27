#
# Cookbook Name:: mrtg
# Recipe:: default
#

include_recipe "apache2"
include_recipe "php"
include_recipe 'mrtg::apache'

group = node['mrtg']['users_databag_group']
begin
  sysadmins = search(:users, "groups:#{group} NOT action:remove")
rescue Net::HTTPServerException
  Chef::Log.fatal("Could not find appropriate items in the \"users\" databag.  Check to make sure there is a users databag and if you have set the \"users_databag_group\" that users in that group exist")
  raise 'Could not find appropriate items in the "users" databag.  Check to make sure there is a users databag and if you have set the "users_databag_group" that users in that group exist'
end

package "mrtg" do
  action :install
end

directory "/etc/mrtg.d/" do
  action :create
  owner "root"
  group "root"
  mode  00750
end

directory "#{node['mrtg']['log_dir']}" do
  action :create
  owner "root"
  group "root"
  mode  00755
end

bash "Create SSL Certificates" do
  cwd "#{node['mrtg']['conf_dir']}"
  code <<-EOH
  umask 077
  openssl genrsa 2048 > mrtg.key
  openssl req -subj "#{node['mrtg']['ssl_req']}" -new -x509 -nodes -sha1 -days 3650 -key mrtg.key > mrtg.crt
  cat mrtg.key mrtg.crt > mrtg.pem
  EOH
  not_if { ::File.exists?("#{node['mrtg']['ssl_cert_file']}") }
end


execute "Generate MRTG index" do
  action :run
  command "indexmaker --perhost #{node['mrtg']['conf_dir'] }/mrtg.cfg > #{node['mrtg']['docroot'] }/index.html"
end

mrtg_bags = MRTGDataBags.new
devices = mrtg_bags.get('devices')

devices = []

search(:devices, "*:*") do |device|
  execute "Configure MRTG for #{device[:id]}" do
    command "cfgmaker public@#{device[:ip]} > /etc/mrtg.d/#{device[:id]}.conf"
    creates "/etc/mrtg.d/#{device[:id]}.conf"
    notifies :run, "execute[Generate MRTG index]"
  end
  devices << device[:id]
end

template "#{node['mrtg']['conf_dir']}/mrtg.cfg" do
  source "mrtg.cfg.erb"
  owner "root"
  group "root"
  mode  00640
  variables :devices => devices.sort
end

template "#{node['mrtg']['conf_dir']}/htpasswd.users" do
  source "htpasswd.users.erb"
  owner  "root"
  group  "apache"
  mode   00640
  variables(:sysadmins => sysadmins)
end

file "/etc/httpd/conf.d/mrtg.conf" do
  action :delete
end
