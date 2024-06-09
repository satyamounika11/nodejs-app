# Node-JS Hello-World Application:

**Pre-requisites:**
1. awscli should be installed
2. Terraform should be installed
3. Git should be installed.

Use "aws configure" to configure your repository to AWS.
   
For a NodeJS application, we need "index.js, package.json and Dockerfile".
* "index.js" which acts as an entry point for the NodeJS application
* "package.json" consists of dependencies that are required for this application
* "Dockerfile" for creating an image of this application.

All these three files are placed in the "/app" folder.

Next, we will create an image of this application through ECR and ECS.

Let's push the image of this application through ECR by creating a repo named "nodejs-app".

Steps to follow:
* Authenticate Docker client to Registry:
```
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 819821926402.dkr.ecr.ap-south-1.amazonaws.com
```
* Build the Docker Image by running the command where the Dockerfile is present:
```
docker build -t nodejs-app .
```
* Tag the Docker Image:
```
docker tag nodejs-app:latest 819821926402.dkr.ecr.ap-south-1.amazonaws.com/nodejs-app:latest
```
* Push the image to the "nodejs-app" ECR repo:
```
docker push 819821926402.dkr.ecr.ap-south-1.amazonaws.com/nodejs-app:latest
```

![image](https://github.com/satyamounika11/nodejs-app/assets/37068004/2398516a-3450-4377-b47f-b57d9209e8a3)


Now, lets create ECS using ECR with Terraform.

A file "main.tf" has been included in "terraform-ecs" folder. This file is responsible for the creation of ECS, Task, ALB, and SG as I have used existing VPC, Public subnets and Execution role for this task.

Follow below steps:
Initialize the repository:
```
terraform init
```
![image](https://github.com/satyamounika11/nodejs-app/assets/37068004/428b183b-bc43-437d-848b-6d29ae645111)

Check the resources that are about to be created:
```
terraform plan
```
![image](https://github.com/satyamounika11/nodejs-app/assets/37068004/1a98797c-8b6a-4279-aa29-e054d0c9a3d1)

Create resources:
```
terraform apply
```
![image](https://github.com/satyamounika11/nodejs-app/assets/37068004/f6e41d3a-3f8b-42ce-a5be-adffbd454918)

# Setup Github-Actions

Go to Settings of the Github repository, In "Secrets --> Actions" --> Create "repository secrets". Give all the sensitive data and its values here.

Go to Actions of this repo, Choose "Deployment with ECS". A new file "aws.yml" or a file with the name of your choice is available. Make sure all the values are present in this file.

# OUTPUT:

**ECS Cluster**:
![image](https://github.com/satyamounika11/nodejs-app/assets/37068004/67c702fe-4857-44e5-8bd8-450e6cfd3274)

**Task**:
![image](https://github.com/satyamounika11/nodejs-app/assets/37068004/4c4b3b2c-9b28-45bb-9404-348620f5ae02)

![image](https://github.com/satyamounika11/nodejs-app/assets/37068004/2ae6428b-5588-46ee-859c-85c7156a49fa)


**Service**:
![image](https://github.com/satyamounika11/nodejs-app/assets/37068004/0a1aeac9-e660-44a9-a8ba-d8e2daff09ae)

# OUTPUT:
![node](https://github.com/satyamounika11/nodejs-app/assets/37068004/f2383dda-acee-4ec7-9ed7-430e802b5735)

**LoadBalancer**:
![image](https://github.com/satyamounika11/nodejs-app/assets/37068004/abbdc175-04a0-45b9-8acb-f2c2a92dd647)


**Health**:
![image](https://github.com/satyamounika11/nodejs-app/assets/37068004/da86c8ad-b617-43e1-98cb-96bb73224a27)

