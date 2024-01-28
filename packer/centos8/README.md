# Packer Project

This GitLab project contains Packer configurations for building a custom Linux machine image on AWS.

## Prerequisites

Before you begin, make sure you have the following installed on your local development workstation:

- [Packer](https://www.packer.io/downloads)
- [AWS CLI](https://aws.amazon.com/cli/)
- AWS Single Sign-On (SSO) configured with the command `aws sso login --no-browser`

## Project Structure

- `linux.pkr.hcl`: Packer configuration file for building the Linux machine image.
- `variables.auto.pkvars.hcl`: Auto variables specific to the project.
- `variables.pkr.hcl`: Regular variables for customizing the Packer build.

## Usage

Follow these steps to build the custom Linux machine image locally:

1. Clone this repository:

   ```
   git clone https://gitlab.com/your-username/your-packer-project.git
   cd your-packer-project
   ```
2. Initialize Packer:
```
packer init .
```
3. Validate the Packer configuration:
```
packer validate .
```
4. Build the custom Linux machine image:
```
packer build .
```
5. (Optional) Run in debug mode:
```
packer build -debug .
```

```
Security Hurdles
The default behavior for Packer is to provision a keypair (for ssh access), instance, and security group on your behalf during the Packer build process. This all looks great on the surface, but take a closer look at the security group and you’ll notice that it opens up the instance to the public Internet which doesn’t feel very secure. The Packer build process can take anywhere from 5-30 minutes depending on the amount of custom configuration you put into your build. A more secure way to do this is by using a bastion instance to tunnel through to get to the private instance for configuration. The cost of using this method is additional configuration and a bastion instance to maintain. An even more secure way to accomplish this is by leveraging AWS’s Systems Manager Session Manager to connect into the instance for configuration. Session Manager is an amazing and underutilized tool for managing EC2 instances in multiple ways.
```