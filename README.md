# NexusNet
This repo makes it easier to run the full NexusNet application. 

## How to run (Linux and MacOS)

### 1. Install dependencies
To run as **DOCKER containers locally**, you need to install:
* You need to install `git`, `docker`, `docker compose`, `java` and `maven`.

To run the jar file version or docker version **in AWS**, you need to install:
* You need to install `git`, `docker`, `docker compose`, `java`, `maven` and `terraform`

### 2. Download and compile projects from git repositories using `compile` script

```
bash compile
```

Right now the script fetches the `main` branch. If you like to fetch another branch **from all the projects** just write the branch name as the first argument. If you want to fetch delevop branches use the following command: 

```
bash compile develop
```

If you want to test your custom **local version**, copy your project folder containing usermanager, postmanager, and frontend folders inside the root of this project.

### 3a. Run the project in Docker

```
docker compose up --build
```
* **You will now be able to use the app at [localhost:3000](http://localhost:3000).**

### 3b. Run the project in AWS using jar files 
Steps:
  1. Install terraform: [Terraform Website](https://developer.hashicorp.com/terraform/install)
  2. Paste the jar files in the `terraform-jars/jars/` folder. \
  (We do not automate this so that you can test with your own jars too)
  3. Run the code in the following order
```
#### SET THE TERRAFORM VARIABLES ####
export TF_VAR_aws_access_key= <YOUR_AWS_ACCESS_KEY> #Ex: "ABCD1EF2GHQIJ33KLMN4"
export TF_VAR_aws_secret_key= <YOUR_AWS_SECRET_KEY> #Ex: "ABCaDEb0cFdeGHI+1KL2MNfgOhOi+sWDEASSDDA"

<- terraform initialize and plan>
terraform init
terraform plan

<- run this command again and agian till you dont see any errors, and all end point urls other than resource already existing ones>
terraform apply -auto-approve #redo till all URLs Published 

<- run this to destroy all resources you have created>
terraform destroy -auto-approve

```
**IMPORTANT:**\
**YOU MAY SEE "CORS" ERRORS IN FRONT-END CONSOLE AS AWS TAKES TIME TO RESOLVE THE POLICIES**

3. The changes you may have to make
    1. Go to the `terraform-jars` folder and set your desired variables for 
        1. AWS variables @ `variables-common.tf`
        2. Frontend @ `variables-frontend.tf`
        3. Usermanager @ `variables-usermanager.tf`
        4. Postmanager @ `variables-postmanager.tf`
        5. API Gateway @ `variables-api.tf`

* **You will now be able to use the app in AWs at  [Generated S3 URL](http://localhost:3000).**


### 4. Reset (if needed)

If you like to update the projects and you feel too lazy to pull them, you can use the `reset` script and then go back to STEP2. **Do not execute this script while in another directory.**

```
bash reset
```

## How to run (Windows)

## Option 1:

Follow the instructions for Linux but use `compile.bat` instead of `compile` and `reset.bat` instead of `reset`.

## Option 2:

The best option right now is to run it in an [emulated bash shell](https://itsfoss.com/install-bash-on-windows/).

## TODO

- [X] Scripts for Windows
- [X] Option to pull main branches