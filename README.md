## Ansible playbook local test

ansible-playbook -v -c local -i '127.0.0.1,' test.yml

```
docker run --rm -it \
  --env-file ~/.aws/credentials \
  packer-ansible build ./packer/vm.pkr.hcl
  ```