# Project 3: CI/CD Pipeline with Jenkins, Kubernetes, and GitHub

## 📌 Project Overview

This project demonstrates a complete CI/CD pipeline for a Java web application using Jenkins, GitHub, Docker, and Kubernetes on AWS. It automates the process of building, containerizing, and deploying a WAR-based Java application to a Kubernetes production-grade cluster.

## 🛠️ Tech Stack

- **Java** (WAR application)
- **Apache Tomcat** (9.x)
- **Docker**
- **Jenkins** (with GitHub Webhook integration)
- **Kubernetes** (multi-node production cluster)
- **AWS EC2** (for Jenkins and K8s nodes)
- **AWS ELB** (external access to app)
- **GitHub** (code repository)

## 🚀 Pipeline Stages

1. **GitHub Webhook Trigger**
   - Automatically triggered when a change is pushed to the `project-3` branch.

2. **Build**
   - Jenkins clones the repo and builds the WAR file using Maven.

3. **Dockerize**
   - Builds a Docker image containing the WAR app deployed to Tomcat.

4. **Push to DockerHub** (or local/private registry if used)

5. **Deploy**
   - Jenkins uses `kubectl` to apply the Kubernetes `Deployment` and `Service` YAMLs.
   - Exposes the app via `LoadBalancer` service type on AWS ELB.

## 📂 Project Structure

proj-mdp-152-155/
├── Dockerfile
├── Jenkinsfile
├── deployment.yaml
├── service.yaml
├── src/
│ └── main/...
└── ...
🌐 Accessing the App
Once deployed, the application is accessible via the AWS Load Balancer URL:
http://<your-elb-dns>
✅ Status
✅ Jenkins webhook triggers build on commit to project-3

✅ WAR file builds and Docker image is pushed

✅ App deployed to Kubernetes and accessible via ELB
