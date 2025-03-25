# Jenkins CI/CD Setup with Docker

A modular, scalable, and reproducible Jenkins setup using Docker Compose, designed for efficient CI/CD environments.

## 🚀 Project Overview

This setup provides a fully containerized, automated Jenkins infrastructure that can be:

- ✅ **Built once, deployed anytime** – Spin up a new Jenkins instance effortlessly.
- ✅ **Lightweight & stateless** – Jenkins runs in a clean, pre-configured container.
- ✅ **Automated & self-testing** – Ensures Jenkins is functional before executing builds.
- ✅ **Scalable & modular** – Uses Docker-in-Docker (DinD) and dynamic agent provisioning.

## 🏗 Key Components & Flow

### 1️⃣ Jenkins Controller

- Runs in a Docker container with a minimal setup.
- Configured via Jenkins Configuration as Code (CASC).
- Does not have the Docker CLI installed (agents handle that).
- Health checks ensure it is up and running before use.

### 2️⃣ Docker-in-Docker (DinD)

- Runs as a separate service to execute Docker commands for builds.
- Jenkins agents connect to DinD instead of the host system.
- Uses an insecure registry setting to work with the private registry.

### 3️⃣ Jenkins Agents (Dynamically Provisioned)

- Spun up inside the DinD environment to execute builds.
- Uses a custom-built agent image, stored in a private registry.
- Allows scalability by running multiple agents in parallel.

### 4️⃣ Private Docker Registry

- Stores the Jenkins agent image and other build artifacts.
- Used to cache dependencies and speed up builds.
- Runs a health check to ensure availability before Jenkins starts.

### 5️⃣ Builder Service (One-time Build Step)

- Builds the Jenkins agent image before deployment.
- Pushes the image to the private Docker registry.
- Ensures that a valid agent image exists before Jenkins starts.

## 🔄 Deployment & CI/CD Flow

### ✅ GitHub Actions (CI Pipeline)

- Runs basic tests to validate the Jenkins setup.
- Ensures Jenkins starts up correctly before allowing deployment.
- Executes `jenkins-sanity-check-pipeline` to verify the setup further.

### ✅ Spin-Up Anytime

- After the initial build, Jenkins can be deployed instantly using Docker Compose.
- No need for manual configuration – CASC takes care of everything.
- The system self-tests at every stage to ensure reliability.

## 🔍 Sanity Check Pipeline (`jenkins-sanity-check-pipeline`)

This pipeline runs essential tests before allowing further builds:

- ✅ Ensures the job does **not** run on the master node.
- ✅ Verifies workspace and checks file creation.
- ✅ Confirms required Jenkins plugins are installed.
- ✅ Runs parallel jobs to test concurrent execution.
- ✅ Checks if Docker is running and accessible.

**🛠 How it Works:**

- The pipeline is triggered with every push to GitHub via GitHub Actions.
- If any test fails, the build is marked as failed, preventing further execution.

## 🛠 Prerequisites

- **Jenkins Controller** running on `http://jenkins:8080`
- **Jenkins Agent(s)** configured with the required labels
- **Docker installed and accessible** on relevant agents
- **Required Jenkins Plugins** installed and up to date
- **Network connectivity** between the Jenkins controller and agents

## 🏗 Sanity Check Pipeline Breakdown

### 1️⃣ Node Validation

- ✅ Ensures the job is **not running on the master node**
- ✅ Confirms execution on an expected agent node (`docker-agent`, `agent-on-hostnet`, etc.)

### 2️⃣ Workspace & File Check

- ✅ Verifies that the **workspace is functional** by creating a test file

### 3️⃣ Agent-to-Controller Network Test

- ✅ Checks that the **Jenkins agent can reach the controller** (`http://jenkins:8080/login`)

### 4️⃣ Plugin Verification

- ✅ Reads `plugins.txt` to validate that **all required plugins are installed**
- ✅ Identifies **missing or outdated plugins**

### 5️⃣ Parallel Job Execution

- ✅ Runs **parallel jobs** to ensure Jenkins can handle concurrent tasks

### 6️⃣ Docker Connectivity Check

- ✅ Ensures **Docker is installed and running**
- ✅ Validates that **the agent running Docker can communicate with the Jenkins controller**

## ▶️ Usage: Running the Sanity Check Pipeline

1. Navigate to Jenkins
2. Trigger the **`jenkins-sanity-check-pipeline`** job
3. Monitor the results in the console output
4. Address any reported issues before proceeding with other builds

## 🔍 Troubleshooting

- If the pipeline fails on **node validation**, ensure jobs are assigned to a valid agent.
- If the **workspace check** fails, verify that the agent has write access.
- If the **network test** fails, check agent connectivity to the controller.
- If **plugin validation** fails, install the missing plugins manually or update outdated ones.
- If **Docker connectivity** fails, ensure the agent has Docker installed and properly configured.

## 🎯 End Goal & Conclusion

This setup creates a portable, pre-configured, and self-testing Jenkins infrastructure that:

- 🚀 Works out of the box – Deploy it on any machine and get a working Jenkins setup instantly.

- 🛠️ Minimizes manual intervention – No need for post-setup tweaks or agent setup.

- 🔄 Ensures reliability – Built-in tests and the sanity check pipeline help prevent common issues before running
  production builds.

- 💡 Scales dynamically – Agents are provisioned as needed inside DinD, ensuring flexibility and scalability.

This automated and self-verifying setup ensures that your Jenkins environment is always ready for production builds,
minimizing potential issues and streamlining your CI/CD workflows.