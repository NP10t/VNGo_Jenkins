# vngo-backend
VNGo is a drive-booking app system. This system has three apps in total: VNGo, VNGo Driver, and VNGo Admin.

This is an end-term project of our four-member team in the Intro to Software Engineering course.

# How to Configure Jenkins

First, updated code is pushed directly to feature/map; there is no test requirement.
Then, create PRs to merge to main. There are two checks to pass:
- continuous-integration/jenkins/branch: The commit from feature/map must pass the unit test.
- continuous-integration/jenkins/pr-merge: The result of merging must pass the unit test.

<img src="https://github.com/user-attachments/assets/b7cea6f1-c711-43f5-90a7-9316f4d316d9" width="400">

## Create Worker Node Jenkins to Run the Job
1) Download Java
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt update
sudo apt install openjdk-21-jdk -y
sudo update-alternatives --config java

2) Create remote working directory for the node
Create working directory
sudo mkdir /jenkins-worker

3) Create the node. The worker will actively connect to the Jenkins controller using JNLP by choosing Launch method: Launch agent by connecting it to the controller.
(image)

4) Download and run agent.jar
Since Jenkins is running on a Windows host, to communicate with the Windows host:
cat /etc/resolv.conf | grep nameserver

However, the user running the Jenkins application needs execution rights for agent.jar in that directory:
sudo chmod 777 /jenkins-worker

Run agent.jar to connect the agent to the Jenkins Controller:
java -jar agent.jar -url http://10.255.255.254:8080/ -secret <secret given by Jenkins after creating the node> -name "first-node" -webSocket -workDir "/jenkins-worker"

(image)

The node is now online.

(image)

## Configure Webhook
Download GitHub plugins
Download Ngrok from https://ngrok.com/downloads/linux
Use Ngrok to expose http://localhost:8080 of Jenkins to the internet
Add webhook to the URL provided by Ngrok

(image)

## Configure Ruleset
Apply to branch main, requiring status checks to pass as shown in this image

(image)

## Configure Jenkins to Run Tests on Branches
Discover branches: Exclude branches that are also filed as PRs.
With this choice, Jenkins won't create continuous-integration/jenkins/pr-head, which is the test for the commit to merge to main.
We don’t need that because we already have continuous-integration/jenkins/branch doing that job.
The continuous-integration/jenkins/branch will automatically be created by Jenkins when there is any push to feature/map.
Even though feature/map doesn't require any test to pass to push, continuous-integration/jenkins/branch just runs by Jenkins and indicates the result as a green tick or red cross as shown in this image.
(image)

Discover pull requests from origin: Merging the pull request with the current target branch revision
This will create continuous-integration/jenkins/pr-merge.

(image)

# How to Create Image of VNGo and Push to DockerHub
