#!/bin/bash

while getopts c:p:i:u: flag
do
    case "${flag}" in
        c) clustername=${OPTARG};;
        i) privatkey=${OPTARG};;
        u) username=${OPTARG};;
    esac
done

cd kubespray


# Deploy Kubespray with Ansible Playbook - run the playbook as root
# The option `--become` is required, as for example writing SSL keys in /etc/,
# installing packages and interacting with various systemd daemons.
# Without --become the playbook will fail to run!
ansible-playbook -u $username --private-key=$privatkey -i inventory/$clustername/hosts.yaml  --become --become-user=root cluster.yml

rm ~/.kube/config
cp inventory/$clustername/artifacts/admin.conf ~/.kube/config