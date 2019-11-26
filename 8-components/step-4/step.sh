#!/usr/bin/env bash

set -x

source ./variables.sh

# An encryption key and an encryption config suitable for encrypting Kubernetes Secrets

### The Encryption Key

ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

### The Encryption Config File

cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

for instance in "${!controllerExternalIps[@]}"; do
  scp -i ~/.ssh/formation encryption-config.yaml formation@${controllerExternalIps[$instance]}:~/
done

