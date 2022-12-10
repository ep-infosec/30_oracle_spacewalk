#!/bin/bash

# This script symlinks everything needed from you git directory into /usr/share/rhn in order
# to run the spacewalk backend directly from git.  NOTE: your spacewalk git directory must be in /spacewalk


if [ ! -d /spacewalk ]; then
   echo "/spacewalk does not exist"
   exit -1
fi

cd /usr/share/rhn/
DIRS="common satellite_exporter satellite_tools server upload_server wsgi"

for dir in $DIRS; do
     python /spacewalk/scripts/link-tree.py /spacewalk/backend/$dir /usr/share/rhn/$dir
done;
SITE_PACKAGES=$(python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")
python /spacewalk/scripts/link-tree.py /spacewalk/backend/spacewalk $SITE_PACKAGES/spacewalk

echo """

Please add:

<Directory "/usr/share/rhn/*">
    Options Indexes FollowSymLinks
    AllowOverride All
    Order allow,deny
    Allow from all
</Directory>

to /etc/httpd/conf.d/zz-spacewalk-server.conf within the virtual host definition and restart httpd

"""
