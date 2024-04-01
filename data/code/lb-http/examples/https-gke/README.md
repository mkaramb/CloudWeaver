# HTTPS load balancer with existing GKE cluster example

[![button](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/GoogleCloudPlatform/terraform-google-lb-http&working_dir=examples/https-gke&page=shell&tutorial=README.md)

This example creates an HTTPS load balancer to forward traffic to a custom URL map. The URL map sends traffic to the `NodePort` of a Kubernetes service running on a GKE cluster. The `/assets` URL map path points to images stored in a Cloud Storage bucket. The TLS key and certificate is generated by Terraform using the [TLS provider](https://www.terraform.io/docs/providers/tls/index.html).

**Figure 1.** *diagram of Google Cloud resources*

![architecture diagram](https://raw.githubusercontent.com/GoogleCloudPlatform/terraform-google-lb-http/master/examples/https-gke/diagram.png)

## Change to the example directory

```
[[ `basename $PWD` != https-gke ]] && cd examples/https-gke
```

## Install Terraform

1. Install Terraform if it is not already installed (visit [terraform.io](https://terraform.io) for other distributions):

## Set up the environment

1. Set the project, replace `YOUR_PROJECT` with your project ID:

```
PROJECT=YOUR_PROJECT
```

```
gcloud config set project ${PROJECT}
```

2. Configure the environment for Terraform:

```
[[ $CLOUD_SHELL ]] || gcloud auth application-default login
export GOOGLE_PROJECT=$(gcloud config get-value project)
```

## Option 1 - Example using new cluster

1. Deploy a new GKE cluster with a named node port:

```
(
    cd gke-node-port/
    terraform init
    terraform plan -out terraform.tfplan
    terraform apply terraform.tfplan
)
```

2. Export the instance group URI, node tag, network name and Project ID as Terraform environment variables:

```
export TF_VAR_backend=$(terraform output -state gke-node-port/terraform.tfstate instance_group)
export TF_VAR_target_tags=$(terraform output -state gke-node-port/terraform.tfstate node_tag)
export TF_VAR_network_name=$(terraform output -state gke-node-port/terraform.tfstate network_name)
export TF_VAR_project=$GOOGLE_PROJECT
```

3. Run Terraform to create the load balancer:

```
terraform init
terraform apply
```

## Option 2 - Example with existing cluster

In this example, you create a Kubernetes `NodePort` service on port `30000` to route traffic to the [`example-app`](./k8s/example-app).

> Remember to include the `--tags` argument so that the network rules apply.

1. Deploy the example app that shows instance info with https redirection:

```
kubectl create -f example-app/
```

2. Set varibles used to identify to your existing cluster:

```
CLUSTER_NAME=YOUR_CLUSTER_NAME
```

```
CLUSTER_ZONE=YOUR_CLUSTER_ZONE
```

3. Find the node tag of your cluster instance group:

```
NODE_TAG=$(gcloud compute instance-templates describe $(gcloud compute instance-templates list --filter=name~gke-${CLUSTER_NAME:0:20} --limit=1 --uri) --format='get(properties.tags.items[0])')
```

4. Find the URI of the instance groups for the GKE cluster, the groups created by GKE are prefixed with your cluster name:

```
INSTANCE_GROUP_URI=$(gcloud container clusters describe ${CLUSTER_NAME} --zone ${CLUSTER_ZONE} --format 'value(instanceGroupUrls[0])' | sed 's/instanceGroupManagers/instanceGroups/')
```

5. Export the instance group URI and network name as Terraform environment variables:

```
export TF_VAR_backend=${INSTANCE_GROUP_URI}
```

```
export TF_VAR_network_name=default
```

6. Add a named port for the load balancer to the instance group:

```
gcloud compute instance-groups set-named-ports ${TF_VAR_backend} --named-ports=http:30000
```

> Backend Services use named ports to forward traffic and must be applied to the instance group.

7. Run Terraform to create the load balancer:

```
terraform init
terraform apply
```

## Testing

1. Wait for the load balancer to be provisioned:

```
./test.sh
```

2. Open URL of load balancer in browser:

```
echo http://$(terraform output load-balancer-ip)| sed 's/"//g'
```

You should see the Google Cloud logo (served from Cloud Storage) and instance details for the sample-app running in the GKE cluster.

## Cleanup

1. Delete the load balancing resources created by terraform:

```
terraform destroy
```

2. Delete the sample app:

```
kubectl delete -f sample-app
```

3. (Option 1 only) Delete the GKE cluster:

```
cd gke-node-port/
terraform destroy
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backend | Map backend indices to list of backend maps. | `any` | n/a | yes |
| name | n/a | `string` | `"tf-lb-https-gke"` | no |
| network\_name | n/a | `string` | `"default"` | no |
| project | n/a | `string` | n/a | yes |
| service\_port | n/a | `string` | `"30000"` | no |
| service\_port\_name | n/a | `string` | `"http"` | no |
| target\_tags | n/a | `string` | `"tf-lb-https-gke"` | no |

## Outputs

| Name | Description |
|------|-------------|
| load-balancer-ip | n/a |
| load-balancer-ipv6 | The IPv6 address of the load-balancer, if enabled; else "undefined" |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->