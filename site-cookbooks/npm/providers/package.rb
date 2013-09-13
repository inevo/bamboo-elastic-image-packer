# encoding: utf-8

action :install do
  NPM ||= "#{node['nodejs']['dir']}/bin/npm"
  Chef::Log.info("Using npm from #{NPM}")
  pkg_id = new_resource.name
  pkg_id += "@#{new_resource.version}" if new_resource.version
  execute "install NPM package #{new_resource.name}" do
    command "#{NPM} -g install #{pkg_id}"
    not_if "#{NPM} -g ls 2> /dev/null | grep '^[├└]─[─┬] #{pkg_id}'"
  end
end

action :uninstall do
  NPM ||= "#{node['nodejs']['dir']}/bin/npm"
  pkg_id = new_resource.name
  pkg_id += "@#{new_resource.version}" if new_resource.version
  execute "uninstall NPM package #{new_resource.name}" do
    command "#{NPM} -g uninstall #{pkg_id}"
    only_if "#{NPM} -g ls 2> /dev/null | grep '^[├└]─[─┬] #{pkg_id}'"
  end
end