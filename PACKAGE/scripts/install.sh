#!/bin/sh
# bootstrap webmin after intiializing environment for DSM
# (c) https://github.com/gnadelwartz
export PATH=$PATH:/opt/bin/:/opt/sbin

PERL=`which perl`

# webmin localtions
webmin="webmin-current"
tarext="tar.gz"
MINICONF=/var/packages/webmin/target/etc/miniserv.conf

# download latest webmin
echo "download latest webmin release ..."
/bin/wget -nv "http://www.webmin.com/download/$webmin.$tarext"

# unpack and install
if [ -f "$webmin.$tarext" ]
then
    echo "unpacking webmin ..."
    /bin/tar -xzf "$webmin.$tarext"
    rm "$webmin.$tarext"

    echo "start installtion of `ls -d webmin*` ..."
    cd webmin*
    install_dir=`grep "^root=" ${MINICONF}| sed 's/.*root=//'`
    config_dir=`grep "env_WEBMIN_CONFIG=" ${MINICONF}| sed 's/.*_WEBMIN_CONFIG=//'`
    var_dir=`grep "env_WEBMIN_VAR=" ${MINICONF}| sed 's/.*_WEBMIN_VAR=//'`
    atboot="NO"
    makeboot="NO"
    nouninstall="YES"
    echo $PERL >$config_dir/perl-path
    echo $var_dir >$config_dir/var-path

    export config_dir atboot nouninstall makeboot nostart
    ./setup.sh $install_dir

    cd ..
    echo cleanup ...
    rm -rf webmin*
else
   echo "Download of webmin failed!"
   exit 1
fi