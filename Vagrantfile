# -*- mode: ruby -*-

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/vivid64'

  config.vm.provider 'virtualbox' do |vb|
    vb.name = 'Dafny'
    vb.memory = '2048'
  end

  config.vm.provision :shell, inline: 'su vagrant /vagrant/provision.sh'
end