packer build \
    -var 'spel_identifier=T12-project-id' \
    -var 'spel_version=dev001' \
    packer/minimal-linux.pkr.hcl