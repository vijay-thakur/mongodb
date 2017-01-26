#
# Cookbook Name:: mongodb
# Recipe:: mongo-install
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


yum_repository 'mongo-repo' do
  description "my mongo Repo"
  baseurl "https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.2/x86_64/"
  gpgkey 'https://www.mongodb.org/static/pgp/server-3.2.asc'
  gpgcheck true
  enabled true
  action :create
end

isupgrade = true

if File.exist?('/etc/init.d/mongod')
  isupgrade = false
end

package ['mongo-10gen-server', 'mongodb-org-shell', 'mongodb-org-mongos', 'mongodb-org-tools']  do
  only_if { isupgrade == true }
end

execute 'extarcting files' do
  command <<-EOF
           set -e
           sudo mkdir -p /data
	         cp -ra /var/lib/mongo /data/
        EOF
    only_if { isupgrade == true }
end

template '/etc/mongod.conf' do
  source node['mongo']['config_file']
  mode '644'
end


execute 'extarcting files' do
  command <<-EOF
           set -e
	         sudo /etc/init.d/mongod start
           sudo chkconfig mongod on
        EOF
    only_if { isupgrade == true }
end
