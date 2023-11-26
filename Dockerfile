FROM hashicorp/packer:1.9

USER root

RUN apk add -v --update --no-cache aws-cli ansible jq openssh bash curl py3-boto3 sudo

# Clean up apt
RUN rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*