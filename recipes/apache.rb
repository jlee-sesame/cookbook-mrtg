include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_php5"

if node['mrtg']['enable_ssl']
  include_recipe "apache2::mod_ssl"
end

apache_site "000-default" do
  enable false
end

public_domain = node['public_domain'] || node['domain']

template "#{node['apache']['dir']}/sites-available/mrtg.conf" do
  source "apache2.conf.erb"
  mode 00644
  variables( 
    :public_domain => public_domain,
    :mrtg_url    => node['mrtg']['url'],
    :https         => node['mrtg']['enable_ssl'],
    :ssl_cert_file => node['mrtg']['ssl_cert_file'],
    :ssl_cert_key  => node['mrtg']['ssl_cert_key']
  )
  if ::File.symlink?("#{node['apache']['dir']}/sites-enabled/mrtg.conf")
    notifies :reload, "service[apache2]"
  end
end

file "#{node['apache']['dir']}/conf.d/mrtg.conf" do
  action :delete
end

apache_site "mrtg.conf"
