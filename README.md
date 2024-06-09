Node-JS Hello-World Application:

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
![image](https://github.com/satyamounika11/nodejs-app/assets/37068004/15a9f023-e6df-46e9-b7cd-73cfb19dde19)

Create resources:
```
terraform apply
```


