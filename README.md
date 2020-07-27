# AWS_Performance_Scalability
Set of projects to plan, design, provision, and monitor infrastructure in AWS using industry-standard and open source tools

## Task 1: Create AWS Architecture Schematics
### Part 1
Plan and provision a cost-effective AWS infrastructure for a new social media application development project for 50,000 single-region users. 

### Part 2
Plan a SERVERLESS architecture schematic for a new application development project. 

## Task 2: Calculate Infrastructure Costs

## Task 3: Configure Permissions.
Update the AWS password policy.
![udacity_password_policy](Task3/udacity_password_policy.png)

Create a Group named CloudTrailAdmins and give it the two CloudTrail privileges.
Configure a user named CloudTrail. Assign CloudTrail to the CloudTrailAdmins group

![UdacityCloudTrailLog](Task3/UdacityCloudTrailLog.png)

## Task 4: Set up Cost Monitoring
![CloudWatch_alarm](Task4/CloudWatch_alarm.png)

## Task 5 : Use Terraform to Provision AWS Infrastructure
### Part 1
Deploy 6 EC2 instances with Terraform using main.tf file
![Terraform_1_1](Task5/Exercise_1/Terraform_1_1.png)

Use Terraform to delete the 2 m4.large instances.
![Terraform_1_2](Task5/Exercise_1/Terraform_1_2.png)

### Part 2
Deploy an AWS Lambda Function using Terraform
CloudWatch log entry for the lambda function execution
![Terraform_2_3](Task5/Exercise_2/Terraform_2_3.png)
