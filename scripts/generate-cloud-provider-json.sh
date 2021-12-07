#! /bin/bash

echo "This script will help you generate the cloud-config.json you need for your Azure environment in the lab."
echo 

echo "Enter Your Azure Subscription Id: "
read AZURE_SUBSCRIPTION_ID

echo "Enter Your Azure TenantId: "
read AZURE_TENANT_ID

echo "Enter Your Azure Client/App Id: "
read AZURE_CLIENT_ID

echo "Enter Your Azure Client Secret: "
read AZURE_CLIENT_SECRET

cat > cloud-config.json << EOF
{
    "cloud": "AzurePublicCloud",
    "tenantId": "${AZURE_TENANT_ID}",
    "aadClientId": "${AZURE_CLIENT_ID}",
    "aadClientSecret": "${AZURE_CLIENT_SECRET}",
    "subscriptionId": "${AZURE_SUBSCRIPTION_ID}",
    "resourceGroup": "Rancher",
    "location": "southeastasia",
    "subnetName": "worker",
    "securityGroupName": "worker",
    "securityGroupResourceGroup": "Rancher",
    "vnetName": "mylab-vnet",
    "vnetResourceGroup": "Rancher",
    "primaryAvailabilitySetName": "worker",
    "routeTableResourceGroup": "Rancher",
    "cloudProviderBackOff": false,
    "useManagedIdentityExtension": false,
    "useInstanceMetadata": true,
    "loadBalancerName": "rke2-lb",
    "loadBalancerSku": "Basic"
}
EOF
