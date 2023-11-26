## Building an AMI for testing in AWS
Sign up for AWS.
Configure your AWS credentials using one of the supported methods for AWS CLI tools, such as setting the 
```AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables.```
Install Packer and make sure it's on your PATH.
Run 
```packer build -only=ubuntu-ami build.json.```
Running automated tests locally against this Packer template
Install Packer and make sure it's on your PATH.
Install Docker and make sure it's on your PATH.
Install Golang and make sure this code is checked out into your GOPATH.
cd test
```
dep ensure
go test -v -run 
``````
