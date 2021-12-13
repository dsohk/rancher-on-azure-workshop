

# Exercise 3: Deploying Apps on RKE 

Duration: 45 minutes

Now, we have got a RKE2 based Kubernetes cluster. Let's deploy a workload on it. In this lab, we are going to deploy two applications with two different approaches. 

1. **Intel-optimized-tensorflow**
2. **Wordpress (Stateful App)**, which stores all data permanently on Azure Disk. 

But before we go ahead with the application deployment, let understand how we can interact with our Kubernetes Cluster.

## Task 1: Interacting with the Kubernetes Cluster

In this step, we will be showing basic interaction with our Kubernetes cluster.

1. Click the top left 3-line bar icon to expand the navigation menu. Click **Cluster Management** menu item.
1.  Click **Explore** button to open the **Cluster Explorer** page of the cluster you want to manage.

![rancher-rke2-cluster-explorer](./images/rancher-rke2-cluster-explorer.png)

**Note the diagrams dials, which illustrate cluster capacity, and the box that show you the recent events in your cluster.**

3. Click the **Kubectl Shell** button (the button with the Prompt icon) in the top right corner of the Cluster Explorer.
4. You can interact with your Kubernetes Cluster using kubeclt. Example kubectl get pods --all-namespaces, will list all pods in all namespace in the cluster. 

![Exercise3-task1-Exploring-cluster-Kubectl-shell](images/Exercise3-task1-Exploring-cluster-Kubectl-shell-16391374923465.png)

5. Click the **Kubeconfig file** button (the button with the Prompt icon) in the top right corner of the Cluster Explorer. It will generate the cluster Kubeconfig file which will be download to your local workstation. You can use the kubectl application on your local system to point to the cluster so that you can manager it form your workstation.

![Exercise3-task1-Exploring-cluster-download-kubeconfig](images/Exercise3-task1-Exploring-cluster-download-kubeconfig.png)

6. In the left menu, you have access to all Kubernetes resources, the Rancher Application Marketplace and additional cluster tools.

![Exercise3-task1-Exploring-cluster-All-Cluster-Resources](images/Exercise3-task1-Exploring-cluster-All-Cluster-Resources.png)



For Persistent Storage, we will be using Azure Disk.  Let see how we can use configure Azure Disk for RKE2 cluster 

## Task 2: Create a default Storage Class

In a Kubernetes Cluster, it can be desirable to have persistent storage available for applications to use. As we have already enabled a Kubernetes Cloud Provider for Azure in this cluster, we will be deploying the **Azure Disk** as data volumes, provided by **[Azure Storage](https://docs.microsoft.com/en-us/azure/aks/concepts-storage)**, to be used by containerized application running in a pod. 

1. In the left navigation menu, open **Storage**  >. **Storage Class** and then click **Create**
2. In the storage class form, please fill in the followings:
   1. Name: **azure-disk**
   2. Provisioner: **Azure Disk**
   3. Storage Account Type: **Standard_LRS**
   4. Kind: **Managed** 

![Exercise3-task2-Persistent-Storage-Storage-Strorage-Class-Create](images/Exercise3-task2-Persistent-Storage-Storage-Strorage-Class-Create.png)

Once the new Storage Class is installed, go to **Storage** > **Storage Classes** and we should see our Azure-Disk Storage Class created. If you observe carefully, under the default column, its shows "-" which indicates there is no default storage class yet. 

![Exercise3-task2-Persistent-Storage-Storage-Strorage-Class-Create-Success](images/Exercise3-task2-Persistent-Storage-Storage-Strorage-Class-Create-Success.png)

Next step would be make Azure-Disk as the default storage class. Click on the **Three Vertical dot**menu at the right hand side of the page against Azure Disk and you can click on Set as **Default** which will now make Azure-Disk as our default storage class

![Exercise3-task2-Persistent-Storage-Storage-Strorage-Class-Azure-disk](images/Exercise3-task2-Persistent-Storage-Storage-Strorage-Class-Azure-disk.png)

We now Azure-Disk as our default Storage Class

![Exercise3-task2-Persistent-Storage-Storage-Strorage-Class-Azure-disk-default-stroage-class](images/Exercise3-task2-Persistent-Storage-Storage-Strorage-Class-Azure-disk-default-stroage-class.png)

## Task 3: Validate the Storage Class is Working

1. Create a PersistentVolumeClaim

   1. Navigate to **Storage** > **PersistentVolumeClaims(PVC)** in the left menu.
   2. Click **Create** button.
   3. Fill in the Storage Class creation form
      1. Name: **test**
      1. Source: Use a Storage Class to provision a new PersistentVolume
      2. storageclass: **azure-disk**
   4. Click **Create** button.

![Exercise3-task3-step1-Validate-Presistent-Storage-working-Presistent-Volume-Claim-Azure-disk](images/Exercise3-task3-step1-Validate-Presistent-Storage-working-Presistent-Volume-Claim-Azure-disk.png)

We can now see a successful PVC, where we are having 10Gi of Azure-Disk.

![Exercise3-task3-step1-Validate-Presistent-Storage-working-Presistent-Volume-Claim-Azure-disk-Success](images/Exercise3-task3-step1-Validate-Presistent-Storage-working-Presistent-Volume-Claim-Azure-disk-Success.png)

We now have the Storage Class and Persistent Volume Claim configured. Now we set-up an test application/Pod to see if Pod is able to use them for it's storage needs. 

2. Create a Pod that consumes the PVC to create a volume via storage class

   1. Navigate to **Workload** > **Pods** in the left menu.

   2. Click **Create from YAML** button

   3. Copy and paste the YAML below and replace the input box in the Pod Create form. 


```YAML
apiVersion: v1
kind: Pod
metadata:
  name: task-pv-pod
  namespace: default
spec:
  volumes:
    - name: task-pv-storage
      persistentVolumeClaim:
        claimName: test
  containers:
    - name: task-pv-container
      image: nginx
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: task-pv-storage
```

4. Click **Create** button to continue.

   Note: Ignore the error in red in the sample output below, we have adapted the YAML Pod Definition file which mean you will not encounter the issue as represented in the sample output below.

![Exercise3-task3-step2-Pod-definition-sample-Consuming-PVC-via-storage-class-Azure-disk](images/Exercise3-task3-step2-Pod-definition-sample-Consuming-PVC-via-storage-class-Azure-disk.png)

5. You should see pod is created successfully with a volume attached to it. This indicates the Storage Class is setup properly.

![Exercise3-task3-step2-Pod-Success-Consuming-PVC-via-storage-class-Azure-disk](images/Exercise3-task3-step2-Pod-Success-Consuming-PVC-via-storage-class-Azure-disk.png)



## Task 4: Application Deployment

### 1. Deploy Intel-Optimized TensorFlow with Jupyter Notebook

The first application we are going to deploy is jupyter book to help AI/ML training on this RKE2 cluster with **Intel(R) Optimization for TensorFlow**, which is a binary distribution of TensorFlow with Intel(R) oneAPI Deep Neural Network Library (oneDNN) primitives, a popular performance library for deep-learning applications.  TensorFlow is a widely used machine-learning framework in the deep-learning arena, demanding efficient use of computational resources. To take full advantage of Intel(R) architecture and to extract maximum performance, the TensorFlow framework has been optimized using oneDNN primitives.

In this task, we will be creating a Kubernetes Deployment and Kubernetes Service for an Intel-optimized tensorflow workload. For the purposes of this lab, we will be using the container image `intel/intel-optimized-tensorflow:2.6.0-jupyter` but you can use your own container image if you have one for testing.

When we deploy our container in a pod, we probably want to make sure it stays running in case of failure or other disruption. Pods by nature will not be replaced when they terminate, so for a web service or something we intend to be always running, we should use a Deployment.

The deployment is a factory for pods, so you'll notice a lot of similairities with the Pod's spec. When a deployment is created, it first creates a replica set, which in turn creates pod objects, and then continues to supervise those pods in case one or more fails.

1. Under the Workloads sections in the left menu, go to **Deployments** and press **Create** in the top right corner and enter the following criteria:

   * Name - **intel**

   - Replicas - 1
   - Container Image - **intel/intel-optimized-tensorflow:2.6.0-jupyter**
   - Under **Ports** click **Add Port**
   - Under **Service Type** choose to create a **Node Port** service
   - Enter **8888** for the **Private Container Port**
   - **Note** the other capabilities you have for deploying your container. We won't be covering these in this lab, but you have plenty of capabilities here.

2. Scroll down and click **Create**

![Exercise3-Task4-Cluster-Deployment](images/Exercise3-Task4-Cluster-Deployment.png)

![rancher-rke2-deploy-intel-tensorflow-jupyter](./images/rancher-rke2-deploy-intel-tensorflow-jupyter.png)

3. You should see a new **intel** deployment. If you click on it, you will see 1 Pod getting deployed. 

![Exercise3-task4-Deploy-Intel-App-Status-Updating](images/Exercise3-task4-Deploy-Intel-App-Status-Updating.png)

![Exercise3-task4-Deploy-Intel-App-Status-Container-Creation](images/Exercise3-task4-Deploy-Intel-App-Status-Container-Creation.png)

![Exercise3-task4-Deploy-Intel-App-Running-Success](images/Exercise3-task4-Deploy-Intel-App-Running-Success.png)

![Exercise3-task4-Deploy-Intel-App-Running-WorkerNode](images/Exercise3-task4-Deploy-Intel-App-Running-WorkerNode.png)

![rancher-rke2-pod-intel-tensorflow-jupyter](./images/rancher-rke2-pod-intel-tensorflow-jupyter.png)

4. Click on **View Logs** of the intel pod. You should notice the token shown in the log entry. Copy this token and you need it when you first time open the jupyter notebook to setup your own password.

![rancher-rke2-deploy-inte-tensorflow-jupyter-log](./images/rancher-rke2-deploy-inte-tensorflow-jupyter-log.png)

5. In the left menu under **Service Discovery** > **Services**, you will find a new Node Port Service which exposes the Intel-Optimized tensorflow with jupyter application publicly on a high port on a node. You can click on the linked Port to directly access it.

![rancher-rke2-service-intel-tensorflow-jupyter](./images/rancher-rke2-service-intel-tensorflow-jupyter.png)

![Exercise3-task4-App-Intel-Services-Type-Nodeport](images/Exercise3-task4-App-Intel-Services-Type-Nodeport.png)

While we looked at the container log entries, we also view the token created by the application. Copy this token as you will need it when you first time open the jupyter notebook to setup your own password.

![Exercise3-task4-App-Intel-WebUI-Entering-Token-Acceessing-IntelApp](images/Exercise3-task4-App-Intel-WebUI-Entering-Token-Acceessing-IntelApp.png)

## Task 5: Run a sample tensorflow code with Jupyter Notebook

Now, let's try to run some sample tensorflow code.

1. Click on the linked port to open the jupyter book in your browser. 
2. Upload a jupyter python book sample which can be downloaded from this sample notebook: https://raw.githubusercontent.com/aymericdamien/TensorFlow-Examples/master/tensorflow_v2/notebooks/3_NeuralNetworks/neural_network.ipynb. Save the content as `.ipynb` extension in your laptop computer.
3. Upload the above saved file into jupyter notebook.
4. Click Run button to execute the sample tensorflow code.

![Exercise3-task5-App-Intel-Upload-Sample-Tensorflow-code-with-JupyterNotebook](images/Exercise3-task5-App-Intel-Upload-Sample-Tensorflow-code-with-JupyterNotebook.png)

![jupyter-notebook-on-rancher-rke2](./images/jupyter-notebook-on-rancher-rke2.png)

### Key take away:

**Intel-optimized TensorFlow Jupyter image provides 15-20% improvement on Azure vs the the  upstream tensorflow/tensorflow:2.6.0-jupyter.**

## Task 6 : Stateless Application Deployment

An important criteria to consider before running a new application, in production, is the app’s underlying architecture. A term often used in this context is that the application is ‘stateless’ or that the application is ‘stateful’. Both types have their own pros and cons.

### Stateless Application 

A stateless application is one which depends on no persistent storage. The only thing your cluster is responsible for is the code, and other static content, being hosted on it. That’s it, no changing databases, no writes and no left over files when the pod is deleted.

we will cover the stateless application in Section 5 - Continuous Deployment(CD). 

### Stateful application

Stateless application on the other hand, has several other parameters it is supposed to look after in the cluster. There are dynamic databases which, even when the app is offline or deleted, persist on the disk. On a distributed system, like Kubernetes, this raises several issues. We will look at them in detail, but first let’s clarify some misconceptions.

Before we proceed to deploy the application, let see what application are readily available in Kubernetes and how to get our own application be made available if required. 

To know what application are available from Rancher out of the box

1. Click the top left 3-line bar icon to expand the navigation menu. Click **Cluster Management** menu item.

1. Click **Explore** button to open the **Cluster Explorer** page of the cluster you want to manage.

1. **App and Marketplace** - **Repository**(**Helm** based). 

1. By default two repository are provided by Rancher 

   1) **Rancher**

   1) **Partners**

![Exercise4-Apps-Marketplace-Repo](images/Exercise4-Apps-Marketplace-Repo.png)

5. Chart shows all the application under the Rancher & Partners Repositories.

![Exercise4-App-MarketPlace-Charts](images/Exercise4-App-MarketPlace-Charts.png)

However if you can't find the desired application under Rancher & Partners, what do you do?

We simply add additional repository to make sure the application are then been made available.  If you use the filter box and search for **wordpress**, your search will result into display zero app with name **wordpress**. 

Now for us to have app (**wordpress**) available , we will need to add the helm based repository which has the application available which kubernetes cluster can easily deploy from .

You can add any external **(Public/Private) Helm repository** to Rancher which will then allow the deployment of the application. 

You can add you public/private repository as well. Let add a new repository.

Let's add the required repository so that we can deploy **wordpress**

 In the left menu go to **Apps & Marketplace** > **Chart repositories**

1. Click on **Create** in the top right

2. Enter the following details:

3. - **Name** - rodeo
   - **Target** - Should be http(s) URL
   - **Index URL** - https://rancher.github.io/rodeo

4. Click on **Create**

5. Once the repository has been synchronized, go to **Apps & Marketplace** > **Charts**. There you will now see several new apps that you can install.

![rancher-rke2-marketplace-addrepo](./images/rancher-rke2-marketplace-addrepo.png)

Check the newly created repository.

![Exercise3-task6-Repository-Create-Success](images/Exercise3-task6-Repository-Create-Success.png)

Now if you search for **wordpress** application, you will get it.

![rancher-rke2-marketplace-rodeo-chart](./images/rancher-rke2-marketplace-rodeo-chart.png)

## Task 7: Creating Wordpress Project in your Kubernetes Cluster

Let's deploy a Wordpress instance into the cluster that uses the Azure Disk storage provider. First create a new project for it:

1. In the left menu go to **Cluster** > **Projects/Namespaces**
2. Click **Create Project** in the top right
3. Give your project a name, like wordpress
4. Note the ability to add members, set resource quotas and a pod security policy for this project.
5. Next create a new namespace in the wordpress project. In the list of all **Projects/Namespaces**, scroll down to the wordpress project and click the **Create Namespace** button.
6. Enter the **Name** wordpress and click **Create**.

Creating Project

![Exercise3-task7-Create-New-Project-Wordpress](images/Exercise3-task7-Create-New-Project-Wordpress.png)

![Exercise3-task7-Create-New-Project-Wordpress-Success](images/Exercise3-task7-Create-New-Project-Wordpress-Success.png)

Creating Namespace

![Exercise3-task7-Create-New-Namespace-wordpress-pg2](images/Exercise3-task7-Create-New-Namespace-wordpress-pg2.png)

## Task 8: Deploy Wordpress as a Stateful Application

In this step, we will be deploying Wordpress in the Kubernetes cluster. This wordpress deployment will utilize azure disk to store our mariadb data persistently.

1. From **Apps & Marketplace** > **Charts** install the **Wordpress** app

2. In step 1 of the install wizard, choose the wordpress namespace and give the installation the name wordpress

3. In step 2 of the install wizard, set:

4. - **Wordpress settings** > **Wordpress password** - to a password of your choice
   - Enable **Wordpress setting** > **Wordpress Persistent Volume Enabled**
   
   ![Exercise3-task8-Apps-MarketPlace-Repo-Wordpress-App](images/Exercise3-task8-Apps-MarketPlace-Repo-Wordpress-App.png)

   
   
   ![Exercise3-task8-Deployment-Wordpress-Create](images/Exercise3-task8-Deployment-Wordpress-Create.png)
   
   
   
   ![rancher-rke2-deploy-wordpress-wordpress-setting](./images/rancher-rke2-deploy-wordpress-wordpress-setting.png)
   
   - Enable **Database setting** > **MariaDB Persistent Volume Enabled**
   
   ![rancher-rke2-deploy-wordpress-database-setting](./images/rancher-rke2-deploy-wordpress-database-setting.png)
   
   
   
   - **Services and Load Balancing** > Uncheck "Expose app using Layer 7 Load Balancer", choose NodePort as Service Type and leave all the rest as default.
   - Scroll to the bottom and click **Install**.

![rancher-rke2-deploy-wordpress-service-setting](./images/rancher-rke2-deploy-wordpress-service-setting.png)

5. Wordpress Deployment will being to create 

   1) Wordpress 

   1) Wordpress-MariaDB conatiners.  MariaDB will be using persistent storage 

![Exercise3-task8-Deployment-In-Progress](images/Exercise3-task8-Deployment-In-Progress.png)

Note that you now have two Persistent Volumes available under **Storage** > **Persistent Volumes**

![Exercise3-task8-Deployment-App-PVC-Claim](images/Exercise3-task8-Deployment-App-PVC-Claim.png)

![Exercise3-task8-Deployment-App-Presisent-Volume](images/Exercise3-task8-Deployment-App-Presisent-Volume.png)

![Exercise3-task8-Deployment-App-Wordpress-Pod-Container-Shell](images/Exercise3-task8-Deployment-App-Wordpress-Pod-Container-Shell-16391497067927.png)

6. You can also watch the container Log for the respective Pod.

![Exercise3-task8-Deployment-App-Wordpress-Pod-Logs](images/Exercise3-task8-Deployment-App-Wordpress-Pod-Logs-16391497177318.png)

![Exercise3-task8-Deployment-App-MariaDB-Container-Shell](images/Exercise3-task8-Deployment-App-MariaDB-Container-Shell-16391498455639.png)

![Exercise3-task8-Deployment-App-MariaDB-Pod-Logs](images/Exercise3-task8-Deployment-App-MariaDB-Pod-Logs-163914985245210.png)

![Exercise3-task8-Deployment-App-MariaDB-Pod-Success](images/Exercise3-task8-Deployment-App-MariaDB-Pod-Success.png)

![Exercise3-task8-Deployment-App-MariaDB-Pod-Logs](images/Exercise3-task8-Deployment-App-MariaDB-Pod-Logs.png)

![Exercise3-task8-Deployment-App-MariaDB-Container-Shell](images/Exercise3-task8-Deployment-App-MariaDB-Container-Shell.png)

7. It may take a few minutes to deploy wordpress in this lab, once the installation is complete, navigate to **Service Discovery** > **Services**. There you will see a new high port next to Wordpress service. Click on the URL to access Wordpress. 

   *Note: You may receive* ***404\****,* ***502\****, or* ***503\*** *errors while the wordpress app is coming up. Simply refresh the page occasionally until Wordpress is available*

![Exercise3-task8-Deployment-Wordpress-Services](images/Exercise3-task8-Deployment-Wordpress-Services.png)

8. Log into Wordpress using your set admin credentials and create a new blog post. 

![Exercise3-task8-Deployment-Wordpress-Up-n-Working](images/Exercise3-task8-Deployment-Wordpress-Up-n-Working.png)

![Exercise3-task8-Deployment-Wordpress-First_Blog1](images/Exercise3-task8-Deployment-Wordpress-First_Blog1.png)

Now for any reason if the wordpress pod get deleted/terminate for any reason, should we be worried about data loss ?

No, since we have application(stateful), it uses persistent storage, in our case Azure-Disk will be retain the data & in-spite of container getting terminated or accidentally deleted, the deployment will also ensure it has the minimum replica which would spin up required no of pods again & our wordpress application will be up again & will display the blog we have created. 

Go ahead & delete the Wordpress pod, you will see as soon as it's terminating, deployment will spin up required container pods. 

![Exercise3-task8-Deployment-App-Wordpress-Pod-Deletion](images/Exercise3-task8-Deployment-App-Wordpress-Pod-Deletion.png)

Deployment re-creating the Wordpress Pods as it's a Replica Set

![Exercise3-task8-Deployment-App-Wordpress-Pod-Terminating](images/Exercise3-task8-Deployment-App-Wordpress-Pod-Terminating.png)

![Exercise3-task8-Deployment-Wordpress-New-Pod-Wordpress-Creation-Stage](images/Exercise3-task8-Deployment-Wordpress-New-Pod-Wordpress-Creation-Stage.png)

Now that the pods are up, you can go to Services & use the node port to access the Wordpress application

![Exercise3-task8-Deployment-Wordpress-New-Pod-Wordpress-Uptime-2-mins-only](images/Exercise3-task8-Deployment-Wordpress-New-Pod-Wordpress-Uptime-2-mins-only.png)

 We can see the blog which we had created previously. 

![Exercise3-task8-Deployment-Wordpress-New-Pod-Wordpress-App-Contents-Not-Lost](images/Exercise3-task8-Deployment-Wordpress-New-Pod-Wordpress-App-Contents-Not-Lost.png)

### Next steps

In this exercise, you deployed two different applications on RKE2 within Rancher Server, both manually or via a helm chart we added onto Rancher marketplace.

Now, you can move ahead to the [last exercise](./04-SecureAndManage-RKE.md) of the lab.





