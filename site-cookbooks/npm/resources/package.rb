actions :install, :uninstall

attribute :name, :name_attribute => true
attribute :version, :default => nil

def initialize(*args)
  super
  @action = :install
end