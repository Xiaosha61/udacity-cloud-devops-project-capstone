# udacity-cloud-devops-project-capstone
This is the capstone project for Udacity DevOps Nanodegree.

## Project files

- application files:
  - index.js
  - .eslintrc.json
  - package.json
  - yarn.lock

- script files:
  - run_docker.sh
  - upload_docker.sh
  - run_kubernetes.sh: used for local run in minikube

- cluster deployment:
  - cloudformation/: build step by step the VPC, Cluster and NodeGroup
  - eksctl/: util scripts that can deploy cluster in one step

## Project Steps

### Containerize the application

1. Identify the application that you're going to use.
2. Build a Docker file to containerize the application.
3. Test the docker file in docker and make sure that it works.

### Create a kubernetes deployment and test it locally with minikube.

1. Now that you have a containerized application with the Docker file, build the image and push it to dockerhub.
2. Create our deployment file in `./deployment/deployment.yaml` that is going to use the image that is in docker hub.
3. Create a service that makes the containers publicly accessible.
4. Create a cluster locally using minikube.
5. [Deploy the service and the deployment to the closer locally and test that the application works](https://youtu.be/WeWv2Htb1-g).

### Create a Jenkins pipeline that:

1. lints
2. builds the docker image
3. push the image to dockerhub
4. deploy the containers to the kubernetes cluster

This [tutorial](https://medium.com/@andresaaap/how-to-install-docker-aws-cli-eksctl-kubectl-for-jenkins-in-linux-ubuntu-18-04-3e3c4ceeb71) is going to be useful for creating installing jenkins.

### Create the kubernetes cluster in aws.

You can do it with [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html) and it is the official eks. This tool is great for deploying cluster to AWS and it uses CloudFormation. It will simplify and speed up the process.

- [Create Your First Application on AWS EKS Cluster](https://medium.com/faun/create-your-first-application-on-aws-eks-kubernetes-cluster-874ee9681293)

1. create an AWS IAM service role with EKS-Cluster use case
  - arn:aws:iam::737302360365:role/eks-cluster-manager-xing
2. Create a VPC to deploy the cluster
  - [stack template](https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-02-11/amazon-eks-vpc-sample.yaml)

Using CloudFormation to create all infrastructures:
```bash
# create VPC
./cloudformation/create-stack.sh my-network-stack ./cloudformation/network.yml ./cloudformation/network-params.json

# create EKS Cluster
./cloudformation/create-stack.sh my-eks-stack ./cloudformation/eks-cluster.yml ./cloudformation/eks-cluster-params.json

# configure kubectl for AWS EKS.
aws eks --region us-west-2 update-kubeconfig --name CapstoneEKS-vy1E65pJBsNA

# create node group to join the cluster
./cloudformation/create-stack.sh my-nodegroup-stack ./cloudformation/eks-nodegroup.yml ./cloudformation/eks-nodegroup-params.json

# copy the NodeInstanceRole ARN from nodegroup stack

# apply ConfigMap
kubectl apply -f ./cloudformation/aws-auth-cm.yml # use the NodeInstanceRole from nodegroup stack

```
As an alternative, using `eksctl`, this is doing the above internally, which brings a lot simplicity
```bash
./eksctl/create-eks-cluster.sh # filled with flags, can use config file as well
```

### deploy application in the cluster created in the last step
```bash
# deploy application
kubectl config use-context arn:aws:eks:us-west-2:737302360365:cluster/CapstoneEKS-vy1E65pJBsNA
kubectl apply -f deployment/deployment.yml
kubectl get nodes
kubectl get deployment
kubectl get pod -o wide
kubectl get service/capstone-project-cloud-devops
```

## My CheatSheet

### Docker

```bash
sudo apt install docker.io
sudo usermod -a -G docker <username>

docker start <my_container>
docker stop <my_container>
docker rm <my_container>

docker exec -it <my_container> ls # any commands that are available in the docker container 
```

### Kubernetes
[kubectl Cheat Sheet - Kubernetes Documentation](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

```bash
kubectl config view # check all Merged kubeconfig settings, which shows which Kubernetes cluster kubectl communicates with.
kubectl config use-context my_cluster_name # switch between clusters
kubectl config current-context # display the current-context

kubectl get all # check all resources in the cluster, including pods, services, deployments

kubectl delete pod <my_pod_name>
```

Minikube - local cluster
```bash
kubectl config use-context minikube
minikube start

# try out
kubectl apply -f deployment/deployment.yaml # contains a service+deployment
kubectl get all
minikube service udacity-devops-capstone

kubectl delete -f deployment/deployment.yaml

```

### Jenkins

- install Jenkins 
  - https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-18-04 
  ```bash
  sudo apt-get update
  sudo apt install -y default-jdk
  wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
  sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
      /etc/apt/sources.list.d/jenkins.list'
  sudo apt-get update
  sudo apt-get install jenkins

  sudo systemctl start jenkins
  ```

- Add a new Pipeline
  - https://www.jenkins.io/doc/pipeline/tour/hello-world/

- Add Plugins
  - in order to use docker agent, plugins need to be added.
  - dashboard --> Manage Jenkins --> Manage Plugins

- Enable Jenkins to push to my dockerhub
  - Otherwise will get `denied: requested access to the resource is denied` on `docker push` in Jenkins
    - need to add credentials in your Jenkins' environment
    - dashboard/<project_job>/credentials
    - job/capstone/credentials/store/folder/domain/
    - Kind: Username with password
      ```
      withDockerRegistry([url: "", credentialsId: "dockerhub"]) {
          sh 'docker push sabbir33/capstone-project-cloud-devops'
      }  
      ```

- Enable Jenkins to access AWS
  - install plugin "Pipeline AWS Plugin", it provides new credential kinds(aws credentials)
  - add the aws keys via: /credentials/store/system/domain/
      ```
      withAWS(credentials: 'aws-creds', region: 'us-west-2') {
          sh "aws s3 ls"
      }
      ```

- Troubleshooting:
  - Got permission denied while trying to connect to the Docker daemon
    ```bash
    sudo chmod 777 /var/run/docker.sock
    ```

  - Your cache folder contains root-owned files, due to a bug in previous versions of npm which has since been addressed.
    https://stackoverflow.com/questions/42743201/npm-install-fails-in-jenkins-pipeline-in-docker
    ```
    // add this in your Jenkinsfile
    environment {
        HOME = '.'
    } 
    ```


## References
- [Capstone, Cloud DevOps Nanodegree FAQ](https://medium.com/@andresaaap/capstone-cloud-devops-nanodegree-4493ab439d48)
- [Jenkins pipeline for blue green deployment using AWS EKS — Kubernetes — Docker](https://medium.com/@andresaaap/jenkins-pipeline-for-blue-green-deployment-using-aws-eks-kubernetes-docker-7e5d6a401021?source=your_stories_page---------------------------)
- [Create Your First Application on AWS EKS Cluster](https://medium.com/faun/create-your-first-application-on-aws-eks-kubernetes-cluster-874ee9681293)
- [Simple blue-green deployment in kubernetes using minikube](https://medium.com/@andresaaap/simple-blue-green-deployment-in-kubernetes-using-minikube-b88907b2e267?source=your_stories_page---------------------------)
- [How to install docker, aws cli, eksctl, kubectl for Jenkins in Linux Ubuntu 18.04?](https://medium.com/@andresaaap/how-to-install-docker-aws-cli-eksctl-kubectl-for-jenkins-in-linux-ubuntu-18-04-3e3c4ceeb71)
- [How to configure and execute a rolling update strategy in kubernetes?](https://medium.com/@andresaaap/how-to-configure-and-execute-a-rolling-update-strategy-in-kubernetes-5e662be968b)
- [Capstone Process Flow](https://knowledge.udacity.com/questions/364415#364440)

