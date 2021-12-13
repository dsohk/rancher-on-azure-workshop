## Before the hands-on lab

Duration: 15 minutes

You should follow all of the steps provided in this section *before* taking part in the hands-on lab ahead of time as some of these steps take time.

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

   - **Storage account** : **storage{Deployementid}**
   - **File Share** : **blob**

   > **Note**: Storage account name should be always unique, you can get the Deployement Id from the **Environment Details** tab.

   ![Cloud Shell Bash Window](https://github.com/CloudLabs-MCW/MCW-Cloud-native-applications/blob/fix/Hands-on%20lab/media/b4-image36.png?raw=true)



Now, you can move ahead to the [first exercise](./01-Install-Rancher.md) of the lab.