# home-assistant Ansible role

Ansible role to install and manage Home Assistant on a raspberry pi via docker
and systemd.


## Usage

Requirements:
- pipenv


### Setup

Install python dependencies

Image the disk.

    $ xzcat ~/downloads/ubuntu-20.04.2-preinstalled-server-armhf+raspi.img.xz | sudo dd of=/dev/sdb

Mount the disk locally and run the playbook to configure cloud-init.

    $ . .env
    $ pipenv run ansible-playbook raspi-image.yml

Eject the disk and install it in the Raspberry Pi. Wait for the instance to boot up. Then run the playbook.

    $ . .env
    $ pipenv run ansible-playbook site.yml -e @secrets/secrets.yml

## Restore backup

Follow [Setup](#setup) to configure a running instance.

Stop home-assistant service.

    $ sudo systemctl stop home-assistant.service

Restore the backup, overwriting any existing configuration. Remember to restore
the database files.

    $ sudo duply home-assistant restore  /var/lib/home-assistant/ --force
    $ sudo mv /var/lib/home-assistant/config/home-assistant_v2.db{.bak,}
    $ sudo mv /var/lib/home-assistant/config/zigbee.db{.bak,}

You can also restore a specific file or from a specific point in time.

    $ sudo duply home-assistant restore /var/lib/home-assistant/ 1W
    $ sudo duply home-assistant fetch /var/lib/home-assistant/ config/configuration.yaml 2H


## Development

Requirements:
- docker
