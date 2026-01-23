 DevOps Take-Home Task: Automated Kubernetes Deployment



 🚀 Live Demo

Application URL: \[http://http://a81872eeb187148b69ecb53c290a5e7d-1863067515.us-east-1.elb.amazonaws.com/](http://http://a81872eeb187148b69ecb53c290a5e7d-1863067515.us-east-1.elb.amazonaws.com/)



(Note: If the link is down, the AWS resources may have been destroyed to prevent cost incurrence.)



---



 📖 Project Overview

This project fulfills the DevOps Engineer Take-Home Task requirements by automating the deployment of a Node.js web application to an AWS EKS (Elastic Kubernetes Service) cluster.



The solution follows the Infrastructure as Code (IaC) principle and implements a fully automated CI/CD pipeline that triggers on every commit to the `main` branch.



 🏗 Architecture

Cloud Provider: AWS (US East 1 Region)

Orchestration: Amazon EKS (Kubernetes v1.29)

Infrastructure as Code: Terraform

Containerization: Docker

CI/CD: GitHub Actions

Networking: AWS VPC \& Classic Load Balancer



---



 ⚙️ Prerequisites

To run this project locally, you need:

AWS CLI (v2.x) - Configured with Administrator credentials.

Terraform (v1.x) - Installed and in your system PATH.

kubectl (v1.29) - Configured to interact with the cluster.

Git - For version control.



---



 🛠 How to Deploy



 1. Infrastructure Provisioning (Terraform)

The `terraform/` directory contains the IaC code to provision the VPC, EKS Cluster, and ECR Repository.



```bash

cd terraform



 Initialize Terraform (download providers)

terraform init



 Apply the configuration (creates AWS resources)

 Note: This takes approx. 15-20 minutes

terraform apply --auto-approve

Outputs: After a successful apply, Terraform will output the cluster\_name and ecr\_url, which are needed for the pipeline.

2. CI/CD Pipeline (GitHub Actions)

The pipeline is defined in .github/workflows/deploy.yml. It handles the following steps automatically:



Checkout Code: Pulls the latest code from GitHub.



Login to AWS ECR: Authenticates with the container registry.



Build \& Push: Builds the Docker image and pushes it to ECR with a unique tag (commit SHA).



Deploy: Updates the Kubernetes manifest (deployment.yaml) with the new image tag and applies it to the EKS cluster using kubectl.



Triggering the Pipeline: Simply push a change to the main branch:

git add .

git commit -m "Trigger deployment"

git push origin main

💡 Design Choices \& Implementation Details

Why Terraform?

Terraform was chosen for its state management capabilities and vast provider ecosystem. The standard terraform-aws-modules were used for the VPC and EKS cluster to follow industry best practices and ensure a stable, production-grade network setup without writing boilerplate code from scratch.



Why GitHub Actions?

GitHub Actions allows for seamless integration since the code is hosted on GitHub. It eliminates the need for managing a separate Jenkins server, reducing operational overhead.



Networking Strategy

VPC: Created a custom VPC with private subnets for worker nodes (security) and public subnets for the Load Balancer.



Service Type: Used type: LoadBalancer for the Kubernetes Service. This automatically provisions an AWS Classic Load Balancer to expose the application to the internet without needing complex Ingress Controller configuration for a simple "Hello World" app.



Application Configuration

The Node.js application was configured to run on Port 3000 instead of Port 80. This is a security best practice for containerized applications to avoid running processes as the root user (which is required for ports < 1024).



📂 Project Structure

devops-task/

├── app/

│   ├── Dockerfile          # Multi-stage build for Node.js

│   ├── package.json        # Dependencies

│   └── server.js           # Express.js Application

├── k8s/

│   ├── deployment.yaml     # Kubernetes Deployment Manifest

│   └── service.yaml        # Kubernetes LoadBalancer Service

├── terraform/

│   ├── main.tf             # Main infrastructure configuration

│   ├── outputs.tf          # Output variables (ECR URL, Cluster Name)

│   ├── variables.tf        # Variable definitions

│   └── versions.tf         # Provider versions

└── .github/

   └── workflows/

       └── deploy.yml      # CI/CD Pipeline definition

