# Exercise 2: Provision Kubernetes on Microsoft Azure within SUSE Rancher

Duration: 30 minutes

At this point, you will configure Rancher to automate VM provisioning on Azure and then deploy Kubernetes on these VMs. We are going to provision a RKE2 cluster using Cluster API within SUSE Rancher.

## Task 1: Provision RKE2 on Azure VMs

Let's configure Rancher and provision a Kubernetes cluster (RKE2) of 2 VMs (one master node and one worker node) on the same Resource Group where the Rancher Server is running on. 



1. Click the top left 3-line bar icon to expand the navigation menu. Click **Cluster Management** menu item.

![rancher-menu-cluster-mgt](./images/rancher-menu-cluster-mgt.png)



2. Choose **Clusters** in the left side menu, click **Create** button on the right to create a new Kubernetes cluster.



![rancher-create-cluster-button](./images/rancher-create-cluster-button.png)



3. On **Create Cluster** page, toggle the switch to indcate that we are going to deploy RKE2. Then, choose **Azure** to continue.



![rancher-provision-rke2-azure](./images/rancher-provision-rke2-azure.png)



4. At this point, we need to configure Rancher to be able to automate provisioning on Azure with a proper cloud credential. Fill in the form with your own credential.
   - Subscription ID: (See lab manual instruction)
   - Client ID: (See lab manual instruction)
   - Client Secret: (See lab manual instruction)


![rancher-create-cluster-azure-credential](./images/rancher-create-cluster-azure-credential.png)







5. You will now be shown a Create Cluster on Azure form. We are going to name the cluster, create 2 machine pools for it (one for master node pool and one for worker nodes pool), and configure Azure cloud provider for this cluster.



![rancher-create-cluster-master-pool](./images/rancher-create-cluster-master-pool.png)



Fill in the form with details below.



- Cluster name: **rke2**
- Setup 2 Machine Pools
   - Pool Name: **master**
     - Machine Count: **1**
     - Roles: **etcd, Control Plane**
     - Location: **SouthEastAsia**
     - Resource Group: **Rancher**
     - Availability Set: **rke2-master-as**
     - Image: **SUSE:opensuse-leap-15-3:gen1:2021.10.12**
     - VM Size: **Standard_A4_v2**
     - (Show Advanced)
       - Subnet: **rke2-master-subnet**
       - Subnet Prefix: **10.0.1.0/24**
       - Virtual Network: **mylab-vnet**
       - Public IP Options: **No Public IP**
       - Network Security Group: **rke2-master-nsg**
   - Pool Name: **worker**
     - Machine Count: **1**
     - Roles: **Worker**
     - Location: **SouthEastAsia**
     - Resource Group: **Rancher**
     - Availability Set: **rke2-worker-as**
     - Image: **SUSE:opensuse-leap-15-3:gen1:2021.10.12**
     - VM Size: **Standard_A4_v2**
     - (Show Advanced)
       - Subnet: **rke2-worker-subnet**
       - Subnet Prefix: **10.0.2.0/24**
       - Virtual Network: **mylab-vnet**
       - Public IP Options: **No Public IP**
       - Network Security Group: **rke2-worker-nsg**
- Scroll down to the **Cluster Configuration** section, under the  **Basics** section, choose **Cloud Provider** as **Azure**. In the given **Cloud Provider Config** field, please paste the configuration from the command line. For details of this configuration, please refer to the [Azure Cloud Provider](https://kubernetes-sigs.github.io/cloud-provider-azure/install/configs/) documentation site.

![rancher-create-cluster-cloud-config](./images/rancher-create-cluster-cloud-config.png)


   ```
   {
       "cloud": "AzurePublicCloud",
       "tenantId": "my-tenant-id",
       "aadClientId": "my-client-id",
       "aadClientSecret": "my-secret",
       "subscriptionId": "my-subscription-id",
       "resourceGroup": "Rancher",
       "location": "southeastasia",
       "subnetName": "rke2-worker-subnet",
       "securityGroupName": "rke2-worker-nsg",
       "securityGroupResourceGroup": "Rancher",
       "vnetName": "mylab-vnet",
       "vnetResourceGroup": "Rancher",
       "primaryAvailabilitySetName": "rke2-worker-as",
       "routeTableResourceGroup": "Rancher",
       "cloudProviderBackOff": false,
       "useManagedIdentityExtension": false,
       "useInstanceMetadata": true,
       "loadBalancerName": "rke2-lb",
       "loadBalancerSku": "basic"    
   }
   ```

- Under **Advanced** section, add **Additional Controller Manager Args** with the line below. (See Rancher Issue [#34367](https://github.com/rancher/rancher/issues/34367))

```
--configure-cloud-routes=false
```

- Click **Create** button to start provisioning.



In about 15-20 mins, the RKE2 cluster will then be provisioned and setup. If you click on the cluster name `rke` in the cluster list, you will see 2 VMs are being provisioned by Rancher for building up this cluster.



![rancher-create-cluster-provisioning](./images/rancher-create-cluster-provisioning.png)





## Task 3: Observe the RKE2 Provisioning Process (help troubleshooting)

While the RKE2 starts provisioning, Rancher spins up pods under `fleet-default` namespace in the cluster, named  `local` where Rancher Server is running,to provision VMs in Azure for RKE2. We can view the logs in these pods via Rancher web interface to inspect the Azure API calls from Rancher. 



Once the machines have completed provisioning, Rancher will automatically provision RKE2 onto the VM. At this point, you can then ssh into the master and worker node within Rancher to inspect what's going on. All these are done by the `rancher-system-agent`.



![rancher-rke2-master-node-ssh-shell](./images/rancher-rke2-master-node-ssh-shell.png)



Run the following command to view the system logs in the SSH shell web console of the master node.

```bash
sudo journalctl -f
```



![rancher-rke2-master-node-viewlogs](./images/rancher-rke2-master-node-viewlogs.png)



The whole RKE2 cluster creation process, from VM provisioning to RKE2 deployment, may take 10-15 mins to complete.



## Task 4: Add New Worker Node on RKE2

Let's add a new worker node on RKE2. In the machine list of the RKE2 cluster detail page, click the + button in the worker pool section. Rancher will then automatically provision a new virtual machine within the same worker node pool and join the new node as part of the RKE2 cluster.



![rancher-rke2-add-worker-node](./images/rancher-rke2-add-worker-node.png)



## Task 5: Expose NGINX Ingress Controller on RKE2 to Azure Load Balancer

By default the ingress controller deployed on RKE is exposed as internal service. Once the RKE2 is provisioned successfully with Azure Cloud Provider enabled. Let's reconfigure the ingress controller to expose its service via Azure Load Balancer.

SSH into master node within SUSE Rancher. Place the following snippet to `/var/lib/rancher/rke2/server/manifests` folder in any of the RKE2 master nodes. This will reconfigure the nginx ingress controller to expose itself to LoadBalancer service.



![rancher-rke2-master-node-config-ingress](./images/rancher-rke2-master-node-config-ingress.png)



```
sudo su 
cd /var/lib/rancher/rke2/server/manifests
```

Save the following content into a file `rke2-ingress-nginx-config.yaml` under this folder. 

```
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-ingress-nginx
  namespace: kube-system
spec:
  valuesContent: |-
    controller:
      service:
        enabled: true
    defaultBackend:
      enabled: true        
```

Once saved, the changes in reconfiguring rke2-ingress-nginx will get effective. As you can see in the Events log of **rke2** cluster in **Cluster Explorer**, **Azure Load Balancer** is now created to route external traffic into Nginx Ingress Controller.



### Next steps

In this exercise, you deployed a Kubernetes cluster (RKE2) within SUSE Rancher web interface with integration of Azure Load Balancer to the built-in NGINX ingress controller in the cluster. We also learned how to examine the logs of the cluster nodes. In the next section, we are going to deploy application onto the RKE2 cluster.









