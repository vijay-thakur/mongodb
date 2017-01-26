#
# Cookbook Name:: mongodb
# Recipe:: default
# Company Name : SourceFuse Technologies Pvt. Ltd.
# Copyright (c) 2016 The Authors, All Rights Reserved.

bash 'extarcting files' do
#  command <<-EOF
        code <<-EOH
        set -e
	sudo mkdir -p /data/mongodb
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
	echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
	sudo apt-get update -y
	sudo apt-get install -y mongodb-org=3.0.9 mongodb-org-server=3.0.9 mongodb-org-shell=3.0.9 mongodb-org-mongos=3.0.9 mongodb-org-tools=3.0.9
	sudo chown -R mongodb:mongodb /data/
	sudo chown -R mongodb:mongodb /data/mongodb/
	echo "# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /data/mongodb
  journal:
    enabled: true
#  engine:
#  mmapv1:
#  wiredTiger:

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0


processManagement:
   fork: true
#security:
#   authorization: enabled
#operationProfiling:

replication:
   replSetName: "synapreplica"
#sharding:

## Enterprise-Only Options:

#auditLog:

#snmp:
" > /etc/mongod.conf
	touch /home/vagrant/mongo.js
	sudo service mongod restart
	sleep 10
echo 'use admin;
rs.initiate();' > /home/vagrant/mongo.js
	chmod 777 /home/vagrant/mongo.js
        sudo chown $USER:$USER /home/vagrant/mongo.js
	mongo < /home/vagrant/mongo.js
        mongo admin --eval "db.getSiblingDB('admin').createUser({ user: 'myadmin', pwd: '1234', roles: ['userAdminAnyDatabase'] });"
        mongo admin --eval "db.admin.insert( {item: 'paint', qty: 20 } );"
        EOH
end
