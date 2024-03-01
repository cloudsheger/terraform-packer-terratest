FROM hashicorp/packer

USER root

RUN apk add -v --update --no-cache aws-cli ansible jq openssh bash curl py3-boto3 sudo

# Copy Packer Arifacts
COPY . .

# Clean up apt
RUN rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*

RUN packer init ./packer/vm.pkr.hcl

CMD ["/bin/sh"]