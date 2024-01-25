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

