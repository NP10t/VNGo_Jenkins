# vngo-backend
VNGo is a drive-booking app system. This system has three apps in total: VNGo, VNGo Driver, and VNGo Admin.

This is an end-term project of our four-member team in the Intro to Software Engineering course.

# How to Configure Jenkins

First, updated code is pushed directly to feature/map; there is no test requirement.
Then, create PRs to merge to main. There are two checks to pass:
- continuous-integration/jenkins/branch: The commit from feature/map must pass the unit test.
- continuous-integration/jenkins/pr-merge: The result of merging must pass the unit test.

<img src="https://github.com/user-attachments/assets/b7cea6f1-c711-43f5-90a7-9316f4d316d9" width="700">

## Create Worker Node Jenkins to Run the Job
1) Download Java
```sh
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt update
sudo apt install openjdk-21-jdk -y
sudo update-alternatives --config java
```
3) Create remote working directory for the node
Create working directory
```sh
sudo mkdir /jenkins-worker
```
5) Create the node. The worker will actively connect to the Jenkins controller using JNLP by choosing Launch method: Launch agent by connecting it to the controller.
<img src="https://github.com/user-attachments/assets/d00f5e84-881a-4b65-b500-839f9e7c8991" width="700">

6) Download and run agent.jar
Since Jenkins is running on a Windows host, to communicate with the Windows host:
```sh
cat /etc/resolv.conf | grep nameserver
```

However, the user running the Jenkins application needs execution rights for agent.jar in that directory:
```sh
sudo chmod 777 /jenkins-worker
```

Run agent.jar to connect the agent to the Jenkins Controller:
```sh
java -jar agent.jar -url http://10.255.255.254:8080/ -secret <secret given by Jenkins after creating the node> -name "first-node" -webSocket -workDir "/jenkins-worker"
```

<img src="https://github.com/user-attachments/assets/990447d3-f9e7-47dd-a051-081c77b91b29" width="700">

The node is now online.

<img src="https://github.com/user-attachments/assets/31a44f73-1fd9-4e8a-9b44-225a1d82e097" width="700">


## Configure Webhook
Download GitHub plugins
Download Ngrok from https://ngrok.com/downloads/linux
Use Ngrok to expose http://localhost:8080 of Jenkins to the internet
Add webhook to the URL provided by Ngrok

<img src="https://github.com/user-attachments/assets/5c4499cc-8d6a-429a-9ae2-888b8771faf0" width="700">

## Configure Ruleset
Apply to branch main, requiring status checks to pass as shown in this image

<img src="https://github.com/user-attachments/assets/3e21942a-a102-4963-997b-c3b1ad0e0b99" width="700">

## Configure Jenkins to Run Tests on Branches
Discover branches: Exclude branches that are also filed as PRs.
With this choice, Jenkins won't create continuous-integration/jenkins/pr-head, which is the test for the commit to merge to main.
We don’t need that because we already have continuous-integration/jenkins/branch doing that job.
The continuous-integration/jenkins/branch will automatically be created by Jenkins when there is any push to feature/map.
<img src="https://github.com/user-attachments/assets/c275d257-9f54-4e15-a178-ed9809a8bda0" width="700">

Even though feature/map doesn't require any test to pass to push, continuous-integration/jenkins/branch just runs by Jenkins and indicates the result as a green tick or red cross as shown in this image.
<img src="https://github.com/user-attachments/assets/763fcc5a-46c0-4b3b-a388-accaaedbf114" width="700">

Discover pull requests from origin: Merging the pull request with the current target branch revision
This will create continuous-integration/jenkins/pr-merge.

<img src="https://github.com/user-attachments/assets/9439db0c-cbaa-4433-b773-58b6ca9706c7" width="700">

# How to Create Image of VNGo and Push to DockerHub
