



# Exercise 3: Managing Kubernetes within SUSE Rancher 

Duration: 45 minutes

At this point, ....



## Task 1: Interacting with the Kubernetes Cluster

In this step, we will be showing basic interaction with our Kubernetes cluster.

1. Click into your newly active cluster.
2. **Note the diagrams dials, which illustrate cluster capacity, and the box that show you the recent events in your cluster.**
3. Click the Kubectl Shell button (the button with the Prompt icon) in the top right corner of the Cluster Explorer, and enter kubectl get pods --all-namespaces and observe the fact that you can interact with your Kubernetes cluster using kubectl.
4. Also take note of the Download Kubeconfig File button next to it which will generate a Kubeconfig file that can be used from your local desktop or within your deployment pipelines.
5. In the left menu, you have access to all Kubernetes resources, the Rancher Application Marketplace and additional cluster tools.



## Task 2: Enable Rancher Monitoring

To deploy the *Rancher Monitoring* feature:

1. **Navigate to Apps & Marketplace. in the left menu**
2. **Under Charts Locate the Monitoring chart, and click on it**
3. On the Monitoring App Detail page click the **Install** button in the top right
4. This leads you to the installation wizard. In the first **Metadata** step, we can leave everything as default and click **Next**.
5. In the **Values** step, select the **Prometheus** section on the left. Change **Resource Limits** > **Requested CPU** from 750m to 250m and **Requested Memory** from 750Mi to 250Mi. This is required because our scenario virtual machine has limited CPU and memory available.
6. Click "Install" at the bottom of the page, and wait for the helm install operation to complete.

Once Monitoring has been installed, you can click on that application under "Installed Apps" to view the various resources that were deployed.

Click Cluster Tools button at the bottom of the left pane in Rancher UI

Click Install button of the Monitoring app.

Tick “Customise Helm options before install” Checkbox and click Next button to continue.

Switch to the Prometheus tab in the helm options page. Change Requested CPU from 750m to 250m.

Click Next and then Install



## Task 3: Working with Rancher Monitoring

Once Rancher Monitoring has been deployed, we can view the various components and interact with them.

1. In the left menu of the Cluster Explorer, select "Monitoring"
2. On the Monitoring Dashboard page, identify the "Grafana" link. Clicking this will proxy you to the installed Grafana server

Once you have opened Grafana, feel free to explore the various dashboard and visualizations that have been setup by default.

These options can be customized (metrics and graphs), but doing so is out of the scope of this scenario.

You will also see new Metrics and Alerts section on the Cluster page as well as on the individual workload pages.











## Task 2: Securing Kubernetes clusters

In this task, ...



## Task 3: Monitoring Kubernetes clusters

In this task, ...





### Next steps

In this exercise, you deployed Rancher Server instance.







