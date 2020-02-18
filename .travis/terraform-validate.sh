#!/bin/bash
# Module terraform validate script

TERRAFORM_VERSION="0.12.20"
TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
TERRAFORM_BIN="${HOME}/terraform/bin"
TERRAFORM="${TERRAFORM_BIN}/terraform"

mkdir -p ${TERRAFORM_BIN}
cd ${TERRAFORM_BIN}
wget ${TERRAFORM_URL}
unzip -o terraform*.zip
rm terraform*.zip

# https://github.com/hashicorp/terraform/issues/21408
# This is needed because the provider schema region is needed, but for testing purposes,
# we don't want to set this on each module.
export AWS_DEFAULT_REGION="us-west-2"

cd "${TRAVIS_BUILD_DIR}"
${TERRAFORM} init -backend=false
${TERRAFORM} validate
