# packer-templates

[![Travis](https://img.shields.io/travis/wporter82/packer-templates.svg?style=flat-square)](https://travis-ci.org/wporter82/packer-templates)

[Packer](https://www.packer.io/) template for [Vagrant](https://www.vagrantup.com/) base boxes

Forked from [kaorimatz/packer-templates](https://github.com/kaorimatz/packer-templates) and modified to build a ColdFusion 11 server.

## Usage

Clone the repository:

    $ git clone https://github.com/wporter82/packer-templates && cd packer-templates

Download SQL Server setup file (optional):
	$ wget https://download.microsoft.com/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/Express%2064BIT/SQLEXPR_x64_ENU.exe

Download ColdFusion setup file (optional):
	$ wget http://integration.stg.ortussolutions.com/artifacts/adobe/coldfusion/11.0.0/ColdFusion_11_WWEJ_linux64.bin

Build a machine image from the template in the repository:

    $ packer build fedora-22-x86_64.json

Add the built box to Vagrant:

    $ vagrant box add fedora-22-x86_64 fedora-22-x86_64.box

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
