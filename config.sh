#!/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS=$(pwd)/credentials.json

gcloud container clusters get-credentials devops-labs01-0 \
    --region=us-east1 

kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin \
  --user $(gcloud config get-value account)

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd --version 7.8.7 -n argocd --create-namespace --values ./argocd/values-without-ha.yml --wait

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argo-pass.pass

echo "ArgoCD password: $(cat argo-pass.pass)"

gcloud container clusters get-credentials devops-labs01-1 \
    --region=us-east1 

kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin \
  --user $(gcloud config get-value account)


gcloud container clusters get-credentials devops-labs01-2 \
    --region=us-east1 

kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin \
  --user $(gcloud config get-value account)