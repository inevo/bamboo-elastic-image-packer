DEPS = .deps
PACKER = $(DEPS)/packer/packer
VAGRANT = /usr/bin/vagrant

$(VAGRANT):
	@echo "Downloading vagrant"
	wget http://files.vagrantup.com/packages/b12c7e8814171c1295ef82416ffe51e8a168a244/vagrant_1.3.1_x86_64.deb -P $(DEPS)
	sudo dpkg -i $(DEPS)/vagrant_1.3.1_x86_64.deb
	rm $(DEPS)/vagrant_1.3.1_x86_64.deb

$(PACKER):
	@echo "Downloading packer"
	wget https://dl.bintray.com/mitchellh/packer/0.3.7_linux_amd64.zip -P $(DEPS)/packer
	unzip -d $(DEPS)/packer $(DEPS)/packer/0.3.7_linux_amd64.zip
	rm $(DEPS)/packer/0.3.7_linux_amd64.zip

aws: $(PACKER)
	$(PACKER) build -only=aws -var-file=aws_config.json bamboo_elastic.json

vagrant: $(VAGRANT)
	$(VAGRANT) up
