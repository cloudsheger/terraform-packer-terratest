#!/bin/bash

sudo dnf -y update
sudo dnf -y install python3 python3-pip podman
sudo dnf -y install gcc openssl-devel libffi-devel python3-devel
sudo dnf -y install python3-cryptography
pip3 install ansible-core --user

pip3 install --user ansible-core
