#!/bin/bash

while getopts c:p:i:u: flag
do
    case "${flag}" in
        c) clustername=${OPTARG};;
        p) ip=${OPTARG};;
    esac
done

cd kubespray


# Install dependencies from ``requirements.txt``
sudo pip3 install -r requirements.txt

# Copy ``inventory/sample`` as ``inventory/$clustername``
cp -rfp inventory/sample inventory/$clustername

# Update Ansible inventory file with inventory builder
declare -a IPS=($ip)
CONFIG_FILE=inventory/$clustername/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# Review and change parameters under ``inventory/$clustername/group_vars``
cat inventory/$clustername/group_vars/all/all.yml
cat inventory/$clustername/group_vars/k8s_cluster/k8s-cluster.yml

