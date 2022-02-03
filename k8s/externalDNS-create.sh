# Create IAM Policy for External DNS for EKS to create hosted zone in Router53 when needed
aws iam create-policy \
    --policy-name ExternalDNSPolicy \
    --policy-document file://externalDNSpolicy.json

# Attach the above policy to the service account
export ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

eksctl create iamserviceaccount \
  --cluster=dev \
  --namespace=default \
  --name=external-dns \
  --attach-policy-arn=arn:aws:iam::${ACCOUNT_ID}:policy/ExternalDNSPolicy \
  --override-existing-serviceaccounts \
  --approve

  # Setup External DNS pod
  kubectl apply -f external-dns.yml