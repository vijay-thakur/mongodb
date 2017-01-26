#
# Cookbook Name:: mongodb
# Recipe:: mongo-install with replication
# Company Name : SourceFuse Technologies Pvt. Ltd.
# Copyright (c) 2016 The Authors, All Rights Reserved.



isreplica = true

template '/etc/mongod.conf' do
  source node['mongo']['replica_file']
  mode '644'
end

template "/opt/mongoinitiate.js" do
  source "mongoinitiate.js.erb"
  mode "0777"
  notifies :start, 'service[mongod]', :immediately
end

execute 'setup initiate' do
  cwd node['mongo']['path']
  command '/usr/bin/mongo admin < /opt/mongoinitiate.js'
  notifies :reload, 'service[mongod]'
  only_if { isreplica == true }
end

template "/opt/mongorepel.js" do
  source "mongorepel.js.erb"
  mode "0777"
  variables( 'ip' => node['mongo']['replica_ip'])
  notifies :start, 'service[mongod]', :immediately
end

execute 'setup replica' do
  cwd node['mongo']['path']
  command <<-EOF
  set -e
  sleep 5
  /usr/bin/mongo admin < /opt/mongorepel.js > /tmp/replica_status.txt
  EOF
  notifies :reload, 'service[mongod]'
  only_if { isreplica == true }
end

service "mongod" do
  supports :status => true, :reload => true, :restart => true
  action [:enable, :start]
end
