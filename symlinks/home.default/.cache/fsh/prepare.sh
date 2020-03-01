#!/bin/bash -eu

TERRAFORM_SECRETS_DIR='secrets'
SCRIPT_DIRECTORY=$(basename $(cd $(dirname ${BASH_SOURCE:-$0}); pwd))
AWS_ACCOUNT_NAME=${SCRIPT_DIRECTORY%.*}

export AWS_ACCESS_KEY_ID=$(tail -1 ${TERRAFORM_SECRETS_DIR}/${AWS_ACCOUNT_NAME}.terraform-admin.credentials.csv | cut -d, -f3)
export AWS_SECRET_ACCESS_KEY=$(tail -1 ${TERRAFORM_SECRETS_DIR}/${AWS_ACCOUNT_NAME}.terraform-admin.credentials.csv | cut -d, -f4)
echo "AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID:0:2}******************"
