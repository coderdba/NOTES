VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider "virtualbox" do |vb|
     vb.customize ["createhd", "--filename", "kitchen-disk.vdi", "--size", "8192"]
     vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--medium", "kitchen-disk.vdi", "--port", "1", "--device", "0", "--type", "hdd"]
  end
end
