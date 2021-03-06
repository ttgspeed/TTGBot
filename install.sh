#!/bin/bash
 
# Source: http://toomuchdata.com/2012/06/25/how-to-install-python-2-7-3-on-centos-6-2/

#modified by https://github.com/ttgspeed/
 
# Install stuff #
#################
 
# Install development tools and some misc. necessary packages
yum -y groupinstall "Development tools"
yum -y install zlib-devel  # gen'l reqs
yum -y install bzip2-devel openssl-devel ncurses-devel  # gen'l reqs
yum -y install mysql-devel  # req'd to use MySQL with python ('mysql-python' package)
yum -y install libxml2-devel libxslt-devel  # req'd by python package 'lxml'
yum -y install unixODBC-devel  # req'd by python package 'pyodbc'
yum -y install sqlite sqlite-devel  # you will be sad if you don't install this before compiling python, and later need it.
# Alias shasum to == sha1sum (will prevent some people's scripts from breaking)
echo 'alias shasum="sha1sum"' >> $HOME/.bashrc
# Install Python 2.7.4 (do NOT remove 2.6, by the way)
wget --no-check-certificate http://www.python.org/ftp/python/2.7.4/Python-2.7.4.tar.bz2
tar xf Python-2.7.4.tar.bz2 
cd Python-2.7.4
./configure --prefix=/usr/local 
make && make altinstall
# Install virtualenv and virtualenvwrapper
# Once you make your first virtualenv, you'll have 'pip' in there.
# I got bitten by trying to install a system-wide (i.e. Python 2.6) version of pip;
# it was clobbering my access to pip from within virtualenvs, and it was frustrating.
# So these commands will install virtualenv/virtualenvwrapper the old school way,
# just so you can make yourself a virtualenv, with pip, and then do everything Python-related
# that you need to do, from in there.
wget --no-check-certificate https://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.9.1.tar.gz#md5=07e09df0adfca0b2d487e39a4bf2270a
tar -xvzf virtualenv-1.9.1.tar.gz 
python virtualenv-1.9.1/setup.py install
wget --no-check-certificate https://pypi.python.org/packages/source/v/virtualenvwrapper/virtualenvwrapper-4.0.tar.gz#md5=78df3b40735e959479d9de34e4b8ba15
tar -xvzf virtualenvwrapper-*
python virtualenvwrapper-4.0/setup.py install
echo 'export WORKON_HOME=~/Envs' >> .bashrc # Change this directory if you don't like it
source $HOME/.bashrc
mkdir -p $WORKON_HOME
echo '. /usr/bin/virtualenvwrapper.sh' >> .bashrc
source $HOME/.bashrc
 
# Done!
# Now you can do: `mkvirtualenv foo --python=python2.7`
 
# Extra stuff #
###############
 
# These items are not required, but I recommend them
 
# Add RPMForge repo
sudo yum -y install http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.i686.rpm
yum updateinfo
# Install trash-cli (safer than 'rm', see here: https://github.com/andreafrancia/trash-cli)
sudo yum -y install python-unipath
sudo yum install http://pkgs.repoforge.org/trash-cli/trash-cli-0.11.2-1.el6.rf.i686.rpm
 
# Add EPEL repo (more details at cyberciti.biz/faq/fedora-sl-centos-redhat6-enable-epel-repo/)
cd /tmp
wget --no-check-certificate http://mirror-fpt-telecom.fpt.net/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm

#install pip and praw
yum -y install python-pip
pip install praw
pip install feedparser
