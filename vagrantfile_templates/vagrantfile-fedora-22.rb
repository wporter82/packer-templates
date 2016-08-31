$script = <<-SHELL
	# Reset CFIDE password
	sudo bash -c 'echo rdspassword=>/opt/coldfusion/cfusion/lib/password.properties'
	sudo bash -c 'echo password=vagrant>>/opt/coldfusion/cfusion/lib/password.properties'
	sudo bash -c 'echo encrypted=false>>/opt/coldfusion/cfusion/lib/password.properties'
	# Unpack settings files if they exist
  if [ -f /vagrant/settings.tar.gz ]; then
    tar -xf /vagrant/settings.tar.gz -C /
  fi
  # Update httpd to point to 'public' folder
  echo "Pointing Apache at /var/www/html/public/"
  sed -i \'/DocumentRoot/s/\\/var\\/www\\/html/\\/var\\/www\\/html\\/public/\' /etc/httpd/conf/httpd.conf
  # Create the public folder if it doesn't exist so the server can start
  if [ ! -d /var/www/html/public ]; then
    echo "public folder does not exist, creating."
    mkdir /var/www/html/public
  fi
  # Disable selinux security
  echo "Disabling SELINUX"
  sudo setenforce 0
  sudo bash -c 'echo SELINUX=disabled > /etc/selinux/config'
  sudo bash -c 'echo SELINUXTYPE=targeted >> /etc/selinux/config'
  # Start Server
  echo "Starting Apache"
  sudo systemctl start httpd
SHELL

Vagrant.configure('2') do |config|
  # Enable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = true

  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
  config.vm.synced_folder "./", "/var/www/html/", id: "vagrant-root", owner: "vagrant", group: "apache", mount_options: ["dmode=775,fmode=664"]
  config.vm.provision "shell", inline: $script
  # Start httpd after the system has loaded in order to give virtualbox time
  # to mount the shared folder
  config.vm.provision "shell", inline: "sudo systemctl start httpd", run: "always"

  # Make sure network adapter is connected (VBox 5.1 bug)
  config.vm.provider 'virtualbox' do |vb|
	  vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
  end
end
