# Default values for installing mongodb

default['mongo']['version'] = '3.2.7'
default['mongo']['config_file'] = 'mongo.conf.erb'
default['mongo']['replica_file'] = 'mongoreplica.conf.erb'
default['mongo']['isupgrade'] = false
default['mongo']['replica_ip'] = '172.31.3.137'
default['mongo']['path'] = '/opt/'
