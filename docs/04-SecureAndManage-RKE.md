



# Exercise 4: Managing Kubernetes within SUSE Rancher 

Duration: 45 minutes

At this point, we are going to bring in observability for the Kubernetes cluster managed by Rancher using open source tools governed by CNCF community, such as prometheus and grafana. Rancher made it easy to add this capability with just a few clicks.

Lastly, before going production, we want to ensure the Kubernetes cluster running the workloads are secure and meet the industry standard security baseline, such as the one from Center for Internet Security (CIS). We will see how Rancher made us productive in ensuring the cluster meet the security standard. 

Can we get interacting section here. It would go with flow of managing Kubernetes.  

## Task 1: Enable Rancher Monitoring

To deploy the *Rancher Monitoring* feature:

1. Click **Cluster Tools** button at the bottom of the left pane in Rancher Cluster Explorer View.

2. Locate the **Monitoring** chart, and click install.

3. This leads you to the installation wizard. In the first **Metadata** step, choose **System** in the **Install into Project** option and click **Next**.

   ![rancher-rke2-cluster-tools](./images/rancher-rke2-cluster-tools.png)

   ![Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-pg1](images/Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-pg1.png)

   

4. In the **Values** step, select the **Prometheus** section on the left. Change **Resource Limits** > **Requested CPU** from 750m to 250m and **Requested Memory** from 750Mi to 250Mi. This is required because our scenario virtual machine has limited CPU and memory available.

![rancher-rke2-deploy-prometheus-cpurequest](./images/rancher-rke2-deploy-prometheus-cpurequest.png)

5. In the Alerting section, continue accepting the default values
6. In Grafana section, continue accepting the default values

![Exercise4-Task1-Rancher-Monitoring-App-AlterManager-Value](images/Exercise4-Task1-Rancher-Monitoring-App-AlterManager-Value.png)

![Exercise4-Task1-Rancher-Monitoring-App-Grafana-Value](images/Exercise4-Task1-Rancher-Monitoring-App-Grafana-Value.png)

6. Click "**Install**" at the bottom of the page, and wait the helm install operation to complete. It may take a few minutes.

![Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Deployment-Status](images/Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Deployment-Status.png)

6. Once Monitoring has been installed, you can click on that application under "Installed Apps" to view the various resources that were deployed.

![Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Deployment-Status-Contariner-Various-Stages](images/Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Deployment-Status-Contariner-Various-Stages.png)

![Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Deployment-Success](images/Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Deployment-Success.png)

## Task 2: Working with Rancher Monitoring

Once Rancher Monitoring has been deployed, we can view the various components and interact with them.

1. In the left menu of the Cluster Explorer, select "Monitoring"
2. On the Monitoring Dashboard page, identify the "Grafana" link. Clicking this will proxy you to the installed Grafana server

![rancher-rke2-monitoring-menu](./images/rancher-rke2-monitoring-menu.png)

1. Once you have opened Grafana, feel free to explore the various dashboard and visualizations that have been setup by default.

![rancher-rke2-monitoring-grafana](./images/rancher-rke2-monitoring-grafana.png)

2. These options can be customized (metrics and graphs), but doing so is out of the scope of this exercise.

3. You will also see new Metrics and Alerts section on the Cluster page as well as on the individual workload pages.

![Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Grafana-Dashboard-Rancher-Node-Instances](images/Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Grafana-Dashboard-Rancher-Node-Instances.png)

![Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Grafana-Dashboard-Rancher-Node1](images/Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Grafana-Dashboard-Rancher-Node1.png)

![Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Grafana-Dashboard-Rancher-Node2](images/Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Grafana-Dashboard-Rancher-Node2.png)

![Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Grafana-Dashboard-API-Server](images/Exercise4-Task1-Deploy-Custer-Monitoring-Rancher-Monitoring-App-Grafana-Dashboard-API-Server.png)

In addition, you can watch the metric details

![Exercise4-Task2-Rancher-Monitoring-RKE2-Homepage-Cluster-Metrics-Detail](images/Exercise4-Task2-Rancher-Monitoring-RKE2-Homepage-Cluster-Metrics-Detail.png)

![Exercise4-Task2-Rancher-Monitoring-RKE2-Homepage-Cluster-Metrics-Summary](images/Exercise4-Task2-Rancher-Monitoring-RKE2-Homepage-Cluster-Metrics-Summary.png)

![Exercise4-Task2-Rancher-Monitoring-RKE2-Homepage-ETCD-Metrics-Summary](images/Exercise4-Task2-Rancher-Monitoring-RKE2-Homepage-ETCD-Metrics-Summary.png)

![Exercise4-Task2-Rancher-Monitoring-RKE2-Homepage-Kubernetes-Component-Metrics-Summary](images/Exercise4-Task2-Rancher-Monitoring-RKE2-Homepage-Kubernetes-Component-Metrics-Summary.png)

## Task 3: Enable CIS Benchmark Scanning

In this task, we are going to scan the Kubernetes cluster to ensure its configured securely before running production workload on it.

1. From the bottom of the left menu pane, click **Cluster Tools**.
2. Locate **CIS Benchmark** and click **Install**
3. In Step 1, choose **System** as **Install into Project** option and click **Next** to continue.
4. Leave the setting as default in Step 2 and click **Install** to continue. It may take a few minutes to complete the installation.
5. Once installation is completed, **CIS Benchmark** menu will appear in the left menu pane. Expand it and click **Scan**.
6. Click Create button on the right to create a new CIS Benchmark scanning job. 
7. Leave the form as is to immediately run the scan once and click Create button to submit the job.
8. It takes a few minutes to complete the first scan. Once completed, you should be able to check the scan report which includes the remedial steps you need to take to harden the cluster.

![Exercise4-Task1-Deploy-CusterTools-CIS-Benchmark](images/Exercise4-Task1-Deploy-CusterTools-CIS-Benchmark.png)

![Exercise4-Task1-Deploy-CusterTools-CIS-Benchmark-2.0.1](images/Exercise4-Task1-Deploy-CusterTools-CIS-Benchmark-2.0.1.png)

![Exercise4-Task1-Deploy-CusterTools-CIS-Benchmark-2.0.1-Values](images/Exercise4-Task1-Deploy-CusterTools-CIS-Benchmark-2.0.1-Values.png)

![Exercise4-Task1-Deploy-CusterTools-CIS-Benchmark-App-Progress](images/Exercise4-Task1-Deploy-CusterTools-CIS-Benchmark-App-Progress.png)

![Exercise4-Task1-Deploy-CusterTools-CIS-Benchmark-App-Success](images/Exercise4-Task1-Deploy-CusterTools-CIS-Benchmark-App-Success.png)

On CIS Benchmarks App deployments, you will be provided with 

1) Benchmark Version 
2) CIS Profiles

Available Benchmark Versions 

![Exercise4-Task1-Deploy-CusterTools-CIS-Benchmark-Versions](images/Exercise4-Task1-Deploy-CusterTools-CIS-Benchmark-Versions.png)

Available CIS Profiles

![Exercise4-Task1-Deploy-CusterTools-CIS-Profiles-Available](images/Exercise4-Task1-Deploy-CusterTools-CIS-Profiles-Available.png)

## Task 4 - How to run a CIS Scan.

1. Go to the **Cluster Explorer** in the Rancher UI. In the top left drop down menu, click **Cluster Explorer > CIS Benchmark.**
2. In the **Scans** section, click **Create.**
3. Choose a cluster scan profile. The profile determines which CIS Benchmark version will be used and which tests will be performed. If you choose the Default profile, then the CIS Operator will choose a profile applicable to the type of Kubernetes cluster it is installed on.
4. Click **Create.**

![Exercise4-Task1-Deploy-CusterTools-CIS-Scan-Create](images/Exercise4-Task1-Deploy-CusterTools-CIS-Scan-Create.png)

![rancher-rke2-cis-scan-create](./images/rancher-rke2-cis-scan-create.png)

Once you hit create, a security-scan-runner container will be spun up as sample below.

![Exercise4-Task1-Deploy-CusterTools-CIS-Scan-Pod-Creations](images/Exercise4-Task1-Deploy-CusterTools-CIS-Scan-Pod-Creations.png)

![Exercise4-Task1-Deploy-CusterTools-CIS-Scan-Pod-Creations-both-worker-nodes](images/Exercise4-Task1-Deploy-CusterTools-CIS-Scan-Pod-Creations-both-worker-nodes.png)

We can see the scan job running.

![Exercise4-Task1-Deploy-CusterTools-CIS-Scan-Running-Status](images/Exercise4-Task1-Deploy-CusterTools-CIS-Scan-Running-Status.png)

Once the scan job is completed, the container created by the scan process is terminated 

![Exercise4-Task1-Deploy-CusterTools-CIS-Scan-Pod-Termination-Post-Run-Opearation](images/Exercise4-Task1-Deploy-CusterTools-CIS-Scan-Pod-Termination-Post-Run-Opearation.png)

We will see the result of the scan. You can also download the result to share with your security practice team or auditors. 

![Exercise4-Task1-Cluster-CIS-Scan-Download-Scan-Report](images/Exercise4-Task1-Cluster-CIS-Scan-Download-Scan-Report.png)

You can see the scan result at high level along with it's status.

![rancher-rke2-cis-scan-result](./images/rancher-rke2-cis-scan-result.png)

Download the report and you can also see the remediation to task/process that needs attention. 

![Exercise4-Task1-Cluster-CIS-Scan-Remediation](images/Exercise4-Task1-Cluster-CIS-Scan-Remediation.png)

In this exercise, we have seen how easy it to install and use important cluster tools such as Promethus, Grafana, CIS Scan.

### Next steps

Now, you can move ahead to the [last exercise](./05. Continious Deployment (Fleet).md) of the lab "Continious Deployment (Fleet)".



Now, you can move ahead to the [next exercise](./05-Continious-deployment-fleet.md) of the lab "Continious Deployment (Fleet)".

