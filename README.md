Description
===========

Installs and configures MRTG as an apache site.  Pulls from a devices databag to determine switches, routers, and other devices to graph.  Currently this is only setup with a package recipe designed to work just on the redhat derived distros.  It borrows heavily from the nagios cookbook by opscode https://github.com/opscode-cookbooks/nagios and uses some things from Stem's MRTG cookbook https://github.com/stem/cookbook-mrtg.  I've tried to create this cookbook to leave room for source recipes and other things to be added easily, but lack the time to further expand it or get it working on other distros, as it does what I need it to now.  Also sorry for the sparse documentation.  This cookbook is very heavily based off the nagios cookbook, so much of their documentation applies, and it uses similar attributes and the same methods to generate the apache site, SSL certs, and htaccess files.  However, the only authentication method I've setup is the use of htaccess, that pulls from the users databag.  Since I'm only using the package resource, and hence installing mrtg via yum, the cookbook is also relying on the RPM package to create the cron job at this point.  Please feel free to use and further expand on this cookbook.

Platform
--------

* Red Hat Enterprise Linux (CentOS/Amazon/Scientific/Oracle) 5.8, 6.3, 6.4

Cookbooks
---------

* apache2
* php
* yum

Notes
---------
If this is run on the same server as the nagios cookbook, you must set an override attribute for the url of either nagios or mrtg, as they will both try to use FQDN for their websites, and will come into conflict.

The cookbook will autodiscover devices in the devices data bag.  Here's an example of a json file for the devices databag.

{
  "id": "corp-sonicwall",
  "fqdn": "corp-sonicwall.mydomain.com",
  "ip": "192.168.0.1"
}
