VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "raring"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"

  # DRY, let's read the config from the packet config
  bamboo_elastic = JSON.parse(File.read("bamboo_elastic.json"))

  bamboo_elastic["provisioners"].each do |p| 
    case p["type"]

      # shell provisioner
      when "shell" 
        p["scripts"].each {|s| 
          config.vm.provision "shell", path: s
        }

      # chef-solo provisioner
      when "chef-solo"
        config.vm.provision :chef_solo do |chef|
          chef.cookbooks_path = p["cookbook_paths"]
          chef.json = p["json"]
          p["run_list"].each {|r| chef.add_recipe r} 
        end

      when "file"
        config.vm.provision "shell", inline: "cp /vagrant/#{p['source']} #{p['destination']}"
    end
  end
  
end
