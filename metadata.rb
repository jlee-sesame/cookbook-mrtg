name			"mrtg"
maintainer		"Jesse Lee"
maintainer_email	""
license			"Apache 2.0"
description		"Installs and configures MRTG"
long_description	IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version			"0.1"

recipe "mrtg", "Installs MRTG as an Apache Site."

%w{ apache2 php yum }.each do |cb|
  depends cb
end

%w{ redhat centos fedora scientific amazon oracle}.each do |os|
  supports os
end
