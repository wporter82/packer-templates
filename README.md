# packer-templates

<!-- [![Travis](https://img.shields.io/travis/wporter82/packer-templates.svg?style=flat-square)](https://travis-ci.org/wporter82/packer-templates) -->

[Packer](https://www.packer.io/) template for [Vagrant](https://www.vagrantup.com/) base box

Forked from [kaorimatz/packer-templates](https://github.com/kaorimatz/packer-templates) and modified to build ColdFusion 11 server

## Usage

Clone the repository:

    $ git clone https://github.com/wporter82/packer-templates && cd packer-templates

Download ColdFusion setup file:

	$ wget http://integration.stg.ortussolutions.com/artifacts/adobe/coldfusion/11.0.0/ColdFusion_11_WWEJ_linux64.bin

Build the machine image from the template in the repository:

    $ packer build fedora-22-x86_64.json

Manually add the built box to Vagrant:

    $ vagrant box add CF11 fedora-22-x86_64.box

Share build box and add it via shared path:

	$ cp fedora-22-x86_64.box $SHARE_LOCATION
	$ cp CFServer.json $SHARE_LOCATION
	$ vagrant box add $SHARE_LOCATION_URI/CFServer.json

NOTE: the URI can be a URL or filepath such as file://share_location

## Configuration

You can configure the template to match your requirements by setting the following [user variables](https://packer.io/docs/templates/user-variables.html).

 User Variable       | Default Value | Description
---------------------|---------------|----------------------------------------------------------------------------------------
 `compression_level` | 6             | [Documentation](https://packer.io/docs/post-processors/vagrant.html#compression_level)
 `cpus`              | 1             | Number of CPUs
 `disk_size`         | 40000         | [Documentation](https://packer.io/docs/builders/virtualbox-iso.html#disk_size)
 `headless`          | 0             | [Documentation](https://packer.io/docs/builders/virtualbox-iso.html#headless)
 `memory`            | 512           | Memory size in MB
 `mirror`            |               | A URL of the mirror where the ISO image is available

### Example

Build an uncompressed Fedora Linux vagrant box with a 4GB hard disk:

    $ packer build -var compression_level=0 -var disk_size=4000 fedora-22-x86_64.json

### ColdFusion Configuration

The image will provision the ColdFusion server with settings if a settings.tar.gz file exists in the folder you vagrant up in.

To package settings for inclusion, spin up a base server and set up everything in CFIDE as desired. Then vagrant ssh into the box and run the following command:
	$ find /opt/coldfusion/ -iname 'neo*.xml' -exec tar -rvf /vagrant/settings.tar {} \; && gzip /vagrant/settings.tar

The settings.tar.gz file will now be on the host and can be included in a new server spin-up.

## Appendix

### FYI

The httpd config is modified to point to /var/www/html/public. The folder is created during provisioning if it doesn't already exist. If you are cloning a website for development, it is recommended to clone it directly into the root of the vagrant folder as public before running vagrant up. This will ensure the server is started and is ready to serve up the site.

### Passwords

- Fedora: vagrant
- CFIDE: vagrant

### Issues

Symbolic links can't be created in Fedora on the vagrant filesystem when the host is Windows. This is a security limitation of Virtualbox and may be changed in the future to allow symlinks.
