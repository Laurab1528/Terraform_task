# AWS VPC, EC2, and Load Balancer with Terraform

This project provisions a secure AWS infrastructure using Terraform. It creates:

- A Virtual Private Cloud (VPC)
- 2 private EC2 instances
- 1 public Load Balancer
- Public and private subnets

## Requirements

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- An AWS account
- AWS credentials configured (via environment variables or `~/.aws/credentials`)

## File Structure

- `main.tf` – Main Terraform configuration (provider, VPC, EC2, Load Balancer)
- `variables.tf` – Input variables (region, subnets, instance type, AMI, etc.)
- `outputs.tf` – Outputs (VPC ID, EC2 IDs, Load Balancer DNS)


## Usage

1. **Clone this repository and enter the directory:**
   ```bash
   git clone https://github.com/Laurab1528/Terraform_task.git
   cd Terraform_task
   ```

2. **Configure your AWS credentials:**
   - Using environment variables:
     ```bash
     export AWS_ACCESS_KEY_ID=your_access_key
     export AWS_SECRET_ACCESS_KEY=your_secret_key
     ```
   - Or using the AWS CLI:
     ```bash
     aws configure
     ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **(Optional) Review the execution plan:**
   ```bash
   terraform plan
   ```

5. **Apply the configuration:**
   ```bash
   terraform apply
   ```
   Type `yes` when prompted.

6. **Check the outputs:**
   - VPC ID
   - EC2 instance IDs
   - Load Balancer DNS name

7. **(Optional) Destroy the infrastructure:**
   ```bash
   terraform destroy
   ```

## Notes
- The EC2 instances are deployed in private subnets and are only accessible through the Load Balancer.
- The Load Balancer is deployed in public subnets and is accessible from the internet.
- You can change the AMI, instance type, or subnet CIDRs by editing `variables.tf` or `terraform.tfvars`.

---

**Author:** Laura Bermudez 
