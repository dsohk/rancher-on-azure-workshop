#! /bin/bash -ex

az group create --name Rancher --location southeastasia

az network vnet create --resource-group Rancher \
  --name mylab-vnet --address-prefix 10.0.0.0/16 \
  --subnet-name rancher-subnet --subnet-prefix 10.0.0.0/24

az vm create --resource-group Rancher \
  --name rancher \
  --admin-username suse \
  --image SUSE:opensuse-leap-15-3:gen1:2021.10.12 \
  --size Standard_B4ms \
  --generate-ssh-keys \
  --public-ip-sku Basic \
  --vnet-name mylab-vnet \
  --subnet rancher-subnet \
  --os-disk-size-gb 50 \
  --verbose 


az vm open-port --port 443 --resource-group rancher --name rancher

export RANCHER_IP=$(az vm show -d -g Rancher -n rancher --query publicIps -o tsv)


ssh -o StrictHostKeyChecking=no suse@$RANCHER_IP 'sudo zypper install -y git jq'

ssh -o StrictHostKeyChecking=no suse@$RANCHER_IP 'git clone https://github.com/dsohk/rancher-on-azure-workshop/'

ssh -o StrictHostKeyChecking=no suse@$RANCHER_IP 'cd rancher-on-azure-workshop/scripts && ./install-rancher.sh'




