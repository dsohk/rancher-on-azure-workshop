

# Exercise 4: Deploying Apps on RKE 

Duration: 45 minutes

At this point, ....

## Task 1: Create a Deployment And Service

In this task, we will be creating a Kubernetes Deployment and Kubernetes Service for an arbitrary workload. For the purposes of this lab, we will be using the container image rancher/hello-world:latest but you can use your own container image if you have one for testing.

When we deploy our container in a pod, we probably want to make sure it stays running in case of failure or other disruption. Pods by nature will not be replaced when they terminate, so for a web service or something we intend to be always running, we should use a Deployment.

The deployment is a factory for pods, so you'll notice a lot of similairities with the Pod's spec. When a deployment is created, it first creates a replica set, which in turn creates pod objects, and then continues to supervise those pods in case one or more fails.

1. Under the Workloads sections in the left menu, go to Deployments and press Create in the top right corner and enter the following criteria:

2. - **Name** - helloworld
   - **Replicas** - 2
   - **Container Image** - rancher/hello-world:latest
   - Under **Ports** click **Add Port**
   - Under **Service Type** choose to create a Node Port service
   - Enter 80 for the **Private Container Port**
   - ** NOTE: ** Note the other capabilities you have for deploying your container. We won't be covering these in this Rodeo, but you have plenty of capabilities here.

3. Scroll down and click **Create**

4. You should see a new **helloworld** deployment. If you click on it, you will see two Pods getting deployed.

5. From here you can click on a Pod, to have a look at the Pod's events. In the **three-dots** menu on a Pod, you can also access the logs of a Pod or start an interactive shell into the Pod.

6. In the left menu under **Service Discovery** > **Services**, you will find a new Node Port Service which exposes the hello world application publicly on a high port on every worker node. You can click on the linked Port to directly access it.





## Task 2: Create a Kubernetes Ingress

In this step, we will be creating a Layer 7 ingress to access the workload we just deployed in the previous step. For this example, we will be using [sslip.io](http://sslip.io/) as a way to provide a DNS hostname for our workload. Rancher will automatically generate a corresponding workload IP.

1. In the left menu under **Service Discovery** go to **Ingresses** and click on **Create*.

2. Enter the following criteria:

3. - **Name** - helloworld
   - **Request Host** - helloworld.3.129.70.76.sslip.io
   - **Path Prefix** - /
   - **Targt Service** - Choose the helloworld-nodeport service from the dropdown
   - **Port** - Choose port 80 from the dropdown

4. Click **Create** and wait for the helloworld.3.129.70.76.sslip.io hostname to register, you should see the rule become **Active** within a few minutes.

5. Click on the hostname and browse to the workload.

** Note: ** You may receive transient 404/502/503 errors while the workload stabilizes. This is due to the fact that we did not set a proper readiness probe on the workload, so Kubernetes is simply assuming the workload is healthy.





## Task 3: Creating Projects in your Kubernetes Cluster

A project is a grouping of one or more Kubernetes namespaces. In this step, we will create an example project and use it to deploy a stateless wordpress.

1. In the left menu go to **Cluster** > **Projects/Namespaces**

2. Click **Create Project** in the top right

3. Give your project a name, like stateless-wordpress

4. - Note the ability to add members, set resource quotas and a pod security policy for this project.

- Click Create button to continue.

1. Next create a new namespace in the stateless-wordpress project. In the list of all **Projects/Namespaces**, scroll down to the stateless-wordpress project and click the **Create Namespace** button.
2. Enter the **Name** stateless-wordpress and click **Create**.



## Task 4: Add a new chart repository

The easiest way to install a complete Wordpress into our cluster, is through the built-in Apps Marketplace. In addition to the Rancher and partner provided apps that are already available. You can add any other Helm repository and allow the installation of the Helm charts in there through the Rancher UI.

1. In the left menu go to **Apps & Marketplace** > **Chart repositories**

2. Click on **Create** in the top right

3. Enter the following details:

4. - **Name** - rodeo
   - **Target** - Should be http(s) URL
   - **Index URL** - https://rancher.github.io/rodeo

5. Click on **Create**

6. Once the repository has been synchronized, go to **Apps & Marketplace** > **Charts**. There you will now see several new apps that you can install.



## Deploy a Wordpress as a Stateless Application

In this step, we will be deploying Wordpress as a stateless application in the Kubernetes cluster.

1. From **Apps & Marketplace** > **Charts** install the **Wordpress** app

2. In step 1 of the install wizard, choose the stateless-wordpress namespace and give the installation the name wordpress

3. In step 2 of the install wizard, set:

4. - **Wordpress settings** > **Wordpress password** - to a password of your choice
   - **Services and Load Balancing** > **Hostname** - wordpress.3.129.70.76.sslip.io

5. Scroll to the bottom and click **Install**.

6. Once the installation is complete, navigate to **Service Discovery** > **Ingresses**. There you will see a new Ingress. Click on the URL to access Wordpress.

7. - *Note: You may receive* ***404\****,* ***502\****, or* ***503\*** *errors while the wordpress app is coming up. Simply refresh the page occasionally until Wordpress is available*

8. Log into Wordpress using your set admin credentials and create a new blog post. Note that if you delete the **wordpress-mariadb-0** pod or click **Redeploy** on the **wordpress-mariadb** StatefulSet you will lose your post. This is because there is no persistent storage under the Wordpress MariaDB StatefulSet.



## Deploy the nfs-server-provisioner into your Kubernetes Cluster

In a Kubernetes Cluster, it can be desirable to have persistent storage available for applications to use. As we do not have a Kubernetes Cloud Provider enabled in this cluster, we will be deploying the **nfs-server-provisioner** which will run an NFS server inside of our Kubernetes cluster for persistent storage. This is not a production-ready solution by any means, but helps to illustrate the persistent storage constructs.

1. From **Apps & Marketplace** > **Charts** install the **nfs-server-provisioner** app
2. In step 1 of the install wizard, choose the kube-system namespace and give the installation the name nfs-server-provisioner
3. In step 2 of the install wizard, you can keep all the settings as default.
4. Scroll to the bottom and click **Install**.
5. Once the app is installed, go to **Storage** > **Storage Classes**
6. Observe the nfs storage class and the checkmark next to it which indicates it is the **Default** storage class.



## Creating a Stateful Wordpress Project in your Kubernetes Cluster

Let's deploy a second Wordpress instance into the cluster that uses the NFS storage provider. First create a new project for it:

1. In the left menu go to **Cluster** > **Projects/Namespaces**

2. Click **Create Project** in the top right

3. Give your project a name, like stateful-wordpress

4. - Note the ability to add members, set resource quotas and a pod security policy for this project.

5. Next create a new namespace in the stateful-wordpress project. In the list of all **Projects/Namespaces**, scroll down to the stateful-wordpress project and click the **Create Namespace** button.

6. Enter the **Name** stateful-wordpress and click **Create**.



## Deploy Wordpress as a Stateful Application

In this step, we will be deploying Wordpress as a stateful application in the Kubernetes cluster. This wordpress deployment will utilize the we deployed in the previous step to store our mariadb data persistently.

1. From **Apps & Marketplace** > **Charts** install the **Wordpress** app

2. In step 1 of the install wizard, choose the stateful-wordpress namespace and give the installation the name wordpress

3. In step 2 of the install wizard, set:

4. - **Wordpress settings** > **Wordpress password** - to a password of your choide
   - Enable **Wordpress setting** > **Wordpress Persistent Volume Enabled**
   - Enable **Database setting** > **MariaDB Persistent Volume Enabled**
   - **Services and Load Balancing** > **Hostname** - stateful-wordpress.3.129.70.76.sslip.io

5. Scroll to the bottom and click **Install**.

6. Once the installation is complete, navigate to **Service Discovery** > **Ingresses**. There you will see a new Ingress. Click on the URL to access Wordpress.

7. - *Note: You may receive* ***404\****,* ***502\****, or* ***503\*** *errors while the wordpress app is coming up. Simply refresh the page occasionally until Wordpress is available*

8. Note that you now have two Persistent Volumes available under **Storage** > **Persistent Volumes**

9. Log into Wordpress using your set admin credentials and create a new blog post. If you delete the **wordpress-mariadb** pod or click **Redeploy** now, your post will not be lost.



### Next steps

In this exercise, you deployed Rancher Server instance.





