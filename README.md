# Project: WordPress on AWS with Auto Scaling

## Réalisé Par
- AARAB Jamal
- BOUALI Haytham
- EL-FLOUCHI Mohammed
- TABARANI Ibtihal

## Acknowledgments
We would like to express our sincere gratitude to Mr. SOUFIANE, our encadrant, for his continuous guidance, support, and valuable feedback throughout this project. His expertise was crucial in the successful completion of this work.

---

## Introduction

This project focuses on deploying a highly available WordPress application on AWS using Terraform. We are leveraging AWS features such as Auto Scaling Groups (ASG), Load Balancers, MySQL RDS for database management, and various networking configurations to ensure that the WordPress application is scalable and fault-tolerant.

---

## Why WordPress?

WordPress was selected for this project for several reasons:
- **Simplicity**: WordPress is a user-friendly platform that is easy to set up and configure, especially with the vast amount of documentation available.
- **Widespread Adoption**: It powers a significant portion of the internet and is known for its compatibility with various hosting environments.
- **Auto-Scaling Support**: Despite the fact that WordPress itself does not natively support auto-scaling, it was chosen due to the lack of alternative applications that could be easily configured to auto-scale.
  - In evaluating alternatives, we could not find any other application with the same level of documentation and native support for auto-scaling.
  - The use of an Auto Scaling Group (ASG) for EC2 instances, coupled with MySQL RDS for the database, allows us to scale WordPress to meet demand while providing high availability.

---

## Architecture

### VPC and Subnet Design
We have created a custom **VPC** to host all the resources, providing an isolated network environment for our WordPress setup.

- **CIDR Block**: `10.0.0.0/16`
- **Subnets**:
  - **Public Subnets**: These subnets are used for placing the EC2 instances and the Load Balancer. We have multiple availability zones (AZs) for redundancy.
  - **Private Subnets**: These subnets host the RDS MySQL database instances to ensure they are not publicly accessible and are isolated from external traffic.

We used dynamic CIDR block allocation for the subnets using Terraform's `cidrsubnet()` function, which ensures that there is no overlap between public and private subnets.

### Security Groups
We created specific **Security Groups** to control traffic:
- **Allow HTTP Security Group**: This security group allows inbound HTTP traffic (port 80) from anywhere (0.0.0.0/0).
- **Database Security Group**: This security group allows traffic only from the WordPress EC2 instances to the MySQL RDS database on port `3306`. It is important to isolate the database from other resources for security.

### Auto Scaling Group (ASG)
- **Launch Template**: We use a launch template to define the EC2 instance configuration (e.g., AMI, instance type, IAM profile).
- **Desired Capacity**: The ASG ensures that the number of EC2 instances running meets the desired capacity, automatically scaling based on demand.
- **Multi-AZ Deployment**: We deploy EC2 instances across multiple availability zones to ensure high availability.
- **Scaling Policies**: Auto Scaling policies are used to scale the number of instances up or down based on CPU utilization or other metrics.

### Load Balancer (ALB)
An **Application Load Balancer (ALB)** is used to distribute traffic across the EC2 instances within the Auto Scaling Group, ensuring that no single instance becomes a bottleneck.
- The ALB routes traffic based on HTTP requests to the EC2 instances in the ASG.
- We use an HTTP listener on port 80, and it is set to forward traffic to the target group containing the EC2 instances.

### MySQL Database (RDS)
- **MySQL RDS**: We are using Amazon RDS for hosting the MySQL database. The database is deployed in a multi-availability zone setup to ensure high availability.
- **Security Group**: The RDS database is protected by a security group that allows connections only from the WordPress EC2 instances.
- **Automated Backups**: Automated backups are enabled to ensure data protection, and a backup retention period of 7 days is configured.

---

## Why These Choices?

### VPC and Subnet Design
- **Isolation**: Using separate public and private subnets ensures that the database and application logic are isolated from the public internet.
- **Redundancy**: By leveraging multiple availability zones (AZs), we provide fault tolerance to both the web application and the database layer.

### Security Groups
- **Least Privilege**: The security groups follow the principle of least privilege, allowing only the necessary communication between the application and the database.

### Auto Scaling Group and Load Balancer
- **Scalability**: The ASG ensures that the WordPress application can handle variable traffic loads, scaling up and down based on demand. The Load Balancer distributes incoming traffic to the available EC2 instances.

### RDS for Database
- **Managed Service**: RDS is used for its managed services, such as automated backups, patching, and scaling. Using RDS reduces operational overhead and improves security by not exposing the database directly to the internet.
- **Multi-AZ Deployment**: Deploying RDS in a multi-availability zone configuration ensures

---

## Problems Faced

During the development of this project, we encountered several challenges:

### 1. **VPC and Subnet CIDR Block Conflicts**
   - We initially faced conflicts while defining the CIDR blocks for the public and private subnets. This was due to overlapping CIDR blocks, which caused the creation of subnets to fail. 
   - **Resolution**: We resolved this issue by using Terraform's dynamic CIDR block allocation with the `cidrsubnet()` function, which automatically assigns non-overlapping CIDR blocks to each subnet.

### 2. **AWS EIP (Elastic IP) Deprecation**
   - We attempted to use Elastic IPs for the NAT Gateway in our private subnets but found that the `aws_eip` resource is now deprecated for new VPC deployments. This limited our ability to assign public IPs to NAT Gateways.
   - **Resolution**: We chose not to pursue a NAT Gateway solution due to the deprecation issue and instead focused on leveraging the VPC’s private and public subnet structure.

### 3. **Database Connectivity in WordPress**
   - WordPress requires manual configuration to connect to a MySQL database after the EC2 instances are deployed. This made the WordPress setup more complex as we had to rely on user intervention for linking the WordPress application with the MySQL RDS instance.
   - **Resolution**: We documented the process for setting up the database connection, but automation was not feasible within the scope of this project.

---

## Unsolved Problems

### 1. **Deprecated Resource: `aws_eip`**
   - As mentioned earlier, we encountered issues with the deprecation of the `aws_eip` resource when attempting to configure a NAT Gateway in the private subnet. 
   - Unfortunately, we couldn’t find an immediate solution, as AWS has recommended moving to other services, such as VPC endpoints and private link, for handling outbound traffic for private subnets.
   - **Next Steps**: Investigate alternative solutions like using VPC endpoints for direct internet access or adjusting the architecture to accommodate these newer features.

---


## Conclusion

This project demonstrates how to deploy a scalable WordPress environment on AWS using Terraform. The architecture leverages key AWS services like EC2, RDS, Auto Scaling, and Load Balancers to create a highly available and fault-tolerant setup. We made careful choices to ensure security, scalability, and ease of use while accommodating the limitations of WordPress's default architecture.

---

## Acknowledgments

Once again, we would like to express our gratitude to Mr. SOUFIANE, our encadrant, for his invaluable support throughout the duration of this project. His insights helped guide us through technical challenges and ensure the project’s success.

---

## Realized By:
- AARAB Jamal
- BOUALI Haytham
- EL-FLOUCHI Mohammed
- TABARANI Ibtihal
