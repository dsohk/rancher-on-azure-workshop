# Exercise 1: Install SUSE Rancher on Microsoft Azure Instance

Duration: 30 minutes

At this point, we are going to setup an instance of SUSE Rancher Server on Azure.

# Deploy SUSE Rancher

### Task 1: Setup Azure Cloud Shell

1. Open a browser, navigate to the link https://portal.azure.com/, and then sign In with your Azure credentials.

   - Azure Usename/Email:
   - Azure Password:

2. If you see the pop-up **Stay Signed in?**, click Yes.

3. If you see the pop-up **You have free Azure Advisor recommendations!**, close the window to continue the lab.

4. If a **Welcome to Microsoft Azure** popup window appears, click **Maybe Later** to skip the tour.

5. In the **Azure portal**, open the **Azure Cloud Shell** by clicking on the cloud shell icon in the top menu bar. Alternatively, you can open cloud shell by navigating to `https://shell.azure.com`.

   ![msazure-cloudshell](./images/msazure-cloudshell.png)

6. After launching the Azure Cloud Shell, select the **Bash** option. Now on You have no storage mounted dialog box click on **Show advanced settings**. Select Create new under Storage account and provide values as below:

   - **Storage account** : **any-of-your-choose-1-random-numbers**
   - **File Share** : **blob**

   > **Note**: Storage account name should be always unique, you can get the Deployement Id from the **Environment Details** tab.

   ![Cloud Shell Bash Window](https://github.com/CloudLabs-MCW/MCW-Cloud-native-applications/blob/fix/Hands-on%20lab/media/b4-image36.png?raw=true)

### Task 2 - Clone GitHub Repository 

**TIPS**: If you want to setup the Rancher Server on Azure automatically (task 1 and 2), we have prepared a script for you. To do this, please follow the steps below.

1. Open Azure Cloud Shell
2. In the Cloud Shell bash terminal, run the following command.

```bash
git clone https://github.com/dsohk/rancher-on-azure-workshop/
cd rancher-on-azure-workshop/scripts
```

![Excercise1-task1-git-clone-azure-workshop](images/Excercise1-task1-git-clone-azure-workshop-16391283982413.png)

### Task 2 - Install Rancher using script.

Run the command to create a resource group on Azure, deploy a VM within this group and install Rancher Server on this VM. This step will take about 10-15 mins to finish.

```bash
./startlab.sh
```

![Excercise1-task1-install-rancher-install-script](images/Excercise1-task1-install-rancher-install-script.png)

![Rancher-Success-and-URL](images/Rancher-Success-and-URL.png)

Rancher is now deployed. We are provided with Rancher URL and Bootstrap password. Open the Rancher URL is new browser Windows and use the Rancher Bootstrap password to login to Rancher. Task 3 cover Rancher Login

## Task 3 - Login to Rancher Server

1. Open a browser and navigate to the Rancher Server URL. Type **thisisunsafe** at the page where there's invalid SSL warning to continue. You will be leading to a first-time setup page of Rancher like below. Enter your bootstrap password to continue..

![Excercise1-task1-rancher-login-bootstrap-password](images/Excercise1-task1-rancher-login-bootstrap-password.png)

2. Set your own password.

![Excercise1-task1-rancher-login-setting-own-password](images/Excercise1-task1-rancher-login-setting-own-password.png)

3. Successful Login and Rancher Homepage.

![Excercise1-task1-rancher-login-success-home-page](images/Excercise1-task1-rancher-login-success-home-page-16391272154692.png)

### Next steps

In this exercise, you have deployed Rancher Server instance. 

In the next exercise, you will configure Rancher Server to create a few VMs on Azure and automate provisioning of a Kubernetes cluster, which integrates with Azure Load Balancer, on these VMs.

Now, you can move ahead to the [second exercise](./02-Provision-Kubernetes.md) of the lab.





