# Detect OS
ARCH = $(shell dpkg --print-architecture 2>/dev/null)
PLATFORM = $(shell uname -i 2>/dev/null)
CODENAME = $(shell lsb_release -sc 2>/dev/null)

DEPS = .deps

PACKER = $(DEPS)/packer/packer
PACKER_VERSION = 0.3.7
PACKER_FILENAME = 0.3.7_linux_$(ARCH).zip

VAGRANT = /usr/bin/vagrant

VBOX = /usr/bin/VBox
VBOX_VERSION = 4.2
VBOX_SOURCES = /etc/apt/sources.list.d/virtualbox.list
 
$(VBOX):
	$(info "Setting up VirtualBox sources for $(CODENAME)")
	@echo "deb http://download.virtualbox.org/virtualbox/debian $(CODENAME) contrib" | sudo tee $(VBOX_SOURCES) 
	wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -

	$(info "Installing VirtualBox")
	sudo apt-get update
	sudo apt-get -y install dkms virtualbox-$(VBOX_VERSION)

$(VAGRANT): $(VBOX)
	$(info "Downloading vagrant")
	wget http://files.vagrantup.com/packages/b12c7e8814171c1295ef82416ffe51e8a168a244/vagrant_1.3.1_x86_64.deb -P $(DEPS)
	sudo dpkg -i $(DEPS)/vagrant_1.3.1_x86_64.deb
	rm $(DEPS)/vagrant_1.3.1_x86_64.deb

$(PACKER):
	$(info "Downloading packer $(PACKER_VERSION)")
	wget https://dl.bintray.com/mitchellh/packer/$(PACKER_FILENAME) -P $(DEPS)/packer
	unzip -d $(DEPS)/packer $(DEPS)/packer/$(PACKER_FILENAME)
	rm $(DEPS)/packer/$(PACKER_FILENAME)

aws: $(PACKER)
	$(PACKER) build -only=aws -var-file=aws_config.json bamboo_elastic.json

vagrant: $(VAGRANT)
	$(VAGRANT) up
