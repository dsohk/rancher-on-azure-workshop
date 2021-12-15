

# Exercise 2: Provision Kubernetes on Microsoft Azure within SUSE Rancher

Duration: 60 minutes

At this point, you will configure Rancher to automate VM provisioning on Azure and then deploy Kubernetes on these VMs. We are going to provision a RKE2 cluster using Cluster API within SUSE Rancher.

## Task 1: Provision RKE2 on Azure VMs

Let's configure Rancher and provision a Kubernetes cluster (RKE2) of 2 VMs (one master node and one worker node) on the same Resource Group where the Rancher Server is running on. 

1. Click the top left 3-line bar icon to expand the navigation menu. Click **Cluster Management** menu item.

![rancher-menu-cluster-mgt](./images/rancher-menu-cluster-mgt.png)

2. Choose **Clusters** in the left side menu, click **Create** button on the right to create a new Kubernetes cluster.

![rancher-create-cluster-button](./images/rancher-create-cluster-button.png)

3. On **Create Cluster** page, toggle the switch to indcate that we are going to deploy RKE2. Then, choose **Azure** to continue.

![rancher-provision-rke2-azure](./images/rancher-provision-rke2-azure.png)

4. At this point, we need to configure Rancher to be able to automate provisioning on Azure with a proper cloud credential. Fill in the form with your own credential, which can be found in the **Environment Details** > **Service Principal Details** tab in your lab instruction section.
   - Subscription ID: (See lab manual instruction)
   - Client ID / Application ID : (See lab manual instruction)
   - Client Secret/ Secret Key : (See lab manual instruction)
   
   On Azure shell execute the below command, it will generate the ouput which you can save as text file which provide you with the above details you are looking for.
   
   ```
   cd rancher-on-azure-workshop/scripts
   ```
   
   ```
   ./generate-cloud-provider-json.sh
   ```
   
   Sample Output below
   
   ![exercise2-task1-using-script-to-fetch-azure-details](images/exercise2-task1-using-script-to-fetch-azure-details.png)
   
   
   
   Use the output to copy & paste the details required. Later we will use the output further in the cluster creation process. 
   
   
   
   ![rancher-create-cluster-azure-credential](./images/rancher-create-cluster-azure-credential.png)
   
5. You will now be shown a Create Cluster on Azure form. We are going to name the cluster, create 2 machine pools for it (one for master node pool and one for worker nodes pool), and configure Azure cloud provider for this cluster.

5.  Fill in the form with details below for MachinePool - Master

- Cluster name: **rke2**

- Setup 2 Machine Pools

  - Pool Name: **master**
    - Machine Count: **1**
    - Roles: **etcd, Control Plane**
    - Location: **SouthEastAsia**
    - Resource Group: **lab**
    - Availability Set: **master**
    - Image: **SUSE:opensuse-leap-15-3:gen1:2021.10.12**
    - VM Size: **Standard_A4_v2**

  MachinePool - Master![Excercise2-Task1-RKE2Cluster-Creation-MachinePool-Master-pg1](images/Excercise2-Task1-RKE2Cluster-Creation-MachinePool-Master-pg1.png)

  (Show Advanced)

  - Fault Domain Count: **1**
  - Update Domain Count: **1**
  - Subnet: **master**
  - Subnet Prefix: **10.0.1.0/24**
  - Virtual Network: **lab-vnet**
  - Network Security Group: **master**
  - Use Managed Disks: **checked**

  ![Excercise2-Task1-RKE2Cluster-Creation-MachinePool-Master-Advance-page-pg2](images/Excercise2-Task1-RKE2Cluster-Creation-MachinePool-Master-Advance-page-pg2.png)

  

  Click on the '+' sign to create additional MachinePool for worker nodes This would create the required workers nodes for the cluster to run the application workloads. 

  ​	Fill in the form with details below for MachinePool - Worker

  - Pool Name: **worker**
    - Machine Count: **1**
    - Roles: **Worker**
    - Location: **SouthEastAsia**
    - Resource Group: **lab**
    - Availability Set: **worker**
    - Image: **SUSE:opensuse-leap-15-3:gen1:2021.10.12**
    - VM Size: **Standard_A4_v2**
    - (Show Advanced)
      - Fault Domain Count: **1**
      - Update Domain Count: **1**
      - Subnet: **worker**
      - Subnet Prefix: **10.0.2.0/24**
      - Virtual Network: **lab-vnet**
      - Network Security Group: **worker**
      - Use Managed Disks: **checked**
      - Add Open Port
        - **30000-32767/tcp (NodePort Range)

  ![Excercise2-Task1-RKE2Cluster-Creation-MachinePool-worker-Advance-page-Ports-pg3](images/Excercise2-Task1-RKE2Cluster-Creation-MachinePool-worker-Advance-page-Ports-pg3.png)

**NOTE:** In this lab, we are going to expose all applications as high port in worker nodes for public access. This requires open up firewall rules for these. For the sake of convenience, we expose a wide range of ports (30000-32767) used by Kubernetes NodePort service to the public in this lab. We suggest you open only the ports you need or use ingress controller/load balancer to expose your applications to the internet in production use. 

Scroll down to the **Cluster Configuration** section, 

Under the  **Basics** section, choose **Cloud Provider** as **Azure**. In the given **Cloud Provider Config** field, please paste the configuration from the command line. For details of this configuration, please refer to the [Azure Cloud Provider](https://kubernetes-sigs.github.io/cloud-provider-azure/install/configs/) documentation site.

** NOTE** Please use the template below for your own cloud config file. You MUST replace the following fields with your own credentials instructed in the lab, before you copy and paste this cloud config json file into the Cloud Provider config input field on Rancher web form.

  * tenantId

  * aadClientId

  * aadClientSecret

  * subscriptionId

    

```
cd rancher-on-azure-workshop/scripts
./generate-cloud-provider-json.sh
```

You can now copy & paste the code output which was created during Task 1 - Step 4.  **Please refer to the Azure Shell for the output.** 

```
{
    "cloud": "AzurePublicCloud",
    "tenantId": "my-tenant-id",
    "aadClientId": "my-client-id",
    "aadClientSecret": "my-secret",
    "subscriptionId": "my-subscription-id",
    "resourceGroup": "lab",
    "location": "southeastasia",
    "subnetName": "worker",
    "securityGroupName": "worker",
    "securityGroupResourceGroup": "lab",
    "vnetName": "mylab-vnet",
    "vnetResourceGroup": "lab",
    "primaryAvailabilitySetName": "worker",
    "routeTableResourceGroup": "lab",
    "cloudProviderBackOff": false,
    "useManagedIdentityExtension": false,
    "useInstanceMetadata": true,
    "loadBalancerName": "rke2-lb",
    "loadBalancerSku": "basic"    
}
```

**Cluster Configuration - Basic Tab/Page**

1. Select Kubernetes Version - **RKE2 v.1.21.6-rke2r1**
2. Container Network Provider - **Calico**
3. Cloud Provider - **Azure**

![rancher-create-cluster-cloud-config](./images/rancher-create-cluster-cloud-config.png)

**Cluster Configuration - Labels and Annotations**, This would be required during exercise 05. 

Labels - Add 

1. **Key**: **distro**

2. **Value**: **rke2**

![Exercise4-Task4-Second-RKE2-Cluster-Creation-Label-Add-Labels](images/Exercise4-Task4-Second-RKE2-Cluster-Creation-Label-Add-Labels.png)

**Cluster Configuration - Advanced**, ***Important configuration, missing will result in issues later in the exercise 03*** 

- Under **Advanced** section, add **Additional Controller Manager Args** with the line below. (See Rancher Issue [#34367](https://github.com/rancher/rancher/issues/34367))

```
--configure-cloud-routes=false
```

![Excercise2-Task1-RKE2Cluster-Creation-MachinePool-Master-Advance-Additional-Controller-Manager-Args](images/Excercise2-Task1-RKE2Cluster-Creation-MachinePool-Master-Advance-Additional-Controller-Manager-Args.png)



- Click **Create** button to start provisioning.

In about approximately 15-20 minutes, the RKE2 cluster will then be provisioned and setup. If you click on the cluster name `rke2` in the cluster list, you will see 2 VMs are being provisioned by Rancher for building up this cluster, one would be the master(Control Plane and Etcd) and worker.

![rancher-create-cluster-provisioning](./images/rancher-create-cluster-provisioning.png)

Rancher will provision the cluster, and you will see different phases of deployment with messages as below.

Master (Control Plane and Etcd)

1. Creating (Azure Machine) in Infrastructure Provider. In our case its Azure. 
2. Awaiting for Cluster Agent to be available. 
3. Awaiting for Infra
4. Running. 

Worker Node

1. Waiting for Control Plane to be available 
2. Waiting for Node registration
3. Waiting for Infra
4. Node condition ready is False
5. Running.

![Excercise2-Task1-Rancher-Successfully-created-master-n-worker-nodes](images/Excercise2-Task1-Rancher-Successfully-created-master-n-worker-nodes.png)

## Task 2: Observe the RKE2 Provisioning Process (help troubleshooting)

While the RKE2 starts provisioning, Rancher spins up pods under `fleet-default` namespace in the cluster, named  `local` where Rancher Server is running,to provision VMs in Azure for RKE2. We can view the logs in these pods via Rancher web interface to inspect the Azure API calls from Rancher. 

![Excercise2-Task1-Rancher-Fleetjob-Creating-RKE2Cluster-MachinePool-master-m-worker](images/Excercise2-Task1-Rancher-Fleetjob-Creating-RKE2Cluster-MachinePool-master-m-worker.png)

Once the machines have completed provisioning, Rancher will automatically provision RKE2 onto the VM. At this point, you can then ssh into the master and worker node within Rancher to inspect what's going on. All these are done by the `rancher-system-agent`.

![rancher-rke2-master-node-ssh-shell](./images/rancher-rke2-master-node-ssh-shell.png)

Run the following command to view the system logs in the SSH shell web console of the master node.

```bash
sudo journalctl -f
```

![Excercise2-Task1-Rancher-Fleetjob-Creating-RKE2Cluster-master-nodes](images/Excercise2-Task1-Rancher-Fleetjob-Creating-RKE2Cluster-master-nodes.png)

Similarly, you can view the system logs via the SSH shell web console of worker node

![Excercise2-Task1-Rancher-Fleetjob-Creating-RKE2Cluster-woker-nodes](images/Excercise2-Task1-Rancher-Fleetjob-Creating-RKE2Cluster-woker-nodes.png)

![rancher-rke2-master-node-viewlogs](./images/rancher-rke2-master-node-viewlogs.png)

The whole RKE2 cluster creation process, from VM provisioning to RKE2 deployment, may take 15-20 minutes  to complete.

## Task 3: Add New Worker Node on RKE2

At this point, we have a working cluster (1 Master & 1 Worker) node.  Let's add a new worker node on RKE2.  Let's see how easy it is to add additional worker nodes to your cluster.

In the machine list of the RKE2 cluster detail page, click the + button in the worker pool section to **Scale Pool Up.** Rancher will then automatically provision a new virtual machine within the same worker node pool and join the new node as part of the RKE2 cluster.

![Excercise2-Task1-RKE2-Cluster-Scaling-additional-worker-nodes-pg1](images/Excercise2-Task1-RKE2-Cluster-Scaling-additional-worker-nodes-pg1.png)

Rancher will go through the process of adding the additional worker node.

1. Create (Azure Machine) in Infra
2. Awaiting for Agent to check in and apply initial plan
3. Waiting for Node to be registered in Kubernetes
4. Node condition ready is False
5. Running.

![Excercise2-Task1-RKE2-Cluster-Scaling-additional-worker-nodes-pg2](images/Excercise2-Task1-RKE2-Cluster-Scaling-additional-worker-nodes-pg2.png)

![Excercise2-Task1-RKE2-Cluster-Scaling-additional-worker-nodes-success-pg3](images/Excercise2-Task1-RKE2-Cluster-Scaling-additional-worker-nodes-success-pg3.png)

### Next steps

In this exercise, you deployed a Kubernetes cluster (RKE2) within SUSE Rancher. We also learned how to examine the logs of the cluster nodes. In the next section, we are going to deploy applications onto the RKE2 cluster.

Now, you can move ahead to the [third exercise](./03-DeployApps-on-RKE.md) of the lab.













