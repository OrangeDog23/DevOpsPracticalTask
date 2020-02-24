# Quick instructions set to run the product

## Prerequirements

+ configured aws cli [link to aws docs](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
+ installed terraform [link to terraform docs](https://learn.hashicorp.com/terraform/getting-started/install.html)
+ configured access to your AWS infrastructure
+ generated ssh key for access to jenkins(for first install)

## Steps to deploy project

### First run

1. Clone project
2. Change terraform/variables.tf according your ifrastructure. In case if you want to change aws-region, you should do it also in terraform/main.tf and in packer/devops-task.json (don't forget to change ssh public key and allowed ip)
3. Create S3 bucket with name, mentioned in terraform/main.tf(in which will be saved terraform state)
4. Change directory to terraform/
5. Run terraform plan generating `terraform plan -out plan.out`
6. Apply terraform plan `terraform apply plan.out`, as result you'll get ip of jenkins instance and url for app(inactive yet jenkins will be configured)

### Configure Jenkins
1. visit address  `http://{jenkins_ip}:8080` with your favorite browser 
2. login to jenkins "Hello page", using token from jenkins instance(it should be available via ssh console)
3. Apply recommended parameters, set new password, finish installation wizard 
4. Add credentials for git repository(username and password)
5. Add new pipeline, set:
  1. Name: any, not empty
  2. Type: pipeline
  3. Definition: Pipeline script from SCM
  4. SCM: git
  5. Repository url: {url to repo}
  6. Credentials: credentials, configured above
  7. Script path: jenkins/update_asg_ami/Jenkinsfile
  
### Run jenkins pipeline

Run jenkins pipeline and wait, until it will be done. Visit {app_url}/send-sns and send a message

