Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty32"
  #fix issue 1
  config.vm.hostname = "yolobox.local"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.provision :shell, path: "provision.sh"
end
