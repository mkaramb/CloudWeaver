# george trammell
import subprocess
from time import sleep
import os

# this script fetches a set list of repositories from https://github.com/orgs/terraform-google-modules/

# parent dir setup
parent_path = "./terraform-google-modules"
if not os.path.exists(parent_path):
    os.makedirs(parent_path)
else:
    raise FileExistsError("Error: terraform-google-modules already exists in this directory.")
os.chdir(parent_path)

# FOR SSH
base_url = "git@github.com:terraform-google-modules/terraform-google-"
# UNCOMMENT FOR HTML
# base_url = "https://github.com/terraform-google-modules/terraform-google-"

repos = [
    # "ai-notebook",
    # "crmint",
    # "example-foundation",
    # "fabric",
    # "secure-cicd",
    # "secured-data-warehouse",
    "address",
    # "alloy-db",
    # "analytics-lakehouse",
    # "anthos-vm",
    "bastion-host",
    # "backup-dr",
    "bigquery",
    "bootstrap",
    # "cloud-armor",
    "cloud-datastore",
    # "cloud-deploy",
    "cloud-dns",
    # "cloud-functions",
    # "cloud-ids",
    "cloud-nat",
    "cloud-operations",
    "cloud-router",
    # "cloud-run",
    "cloud-storage",
    # "cloud-workflows",
    "composer",
    "container-vm",
    "data-fusion",
    "dataflow",
    "datalab",
    "event-function",
    "folders",
    "gcloud",
    "github-actions-runners",
    # "gke-gitlab",
    "group",
    "gsuite-export",
    "healthcare",
    "iam",
    "jenkins",
    "kms",
    "kubernetes-engine",
    "lb",
    "lb-http",
    "lb-internal",
    # "load-balanced-vms",
    # "log-analysis",
    "log-export",
    # "media-cdn-vod",
    "memorystore",
    "network",
    # "network-forensics",
    "org-policy",
    # "out-of-band-security-3P",
    # "project-factory",
    "pubsub",
    "sap",
    "scheduled-function",
    # "secret-manager",
    "service-accounts",
    "slo",
    "sql-db",
    "startup-scripts",
    # "three-tier-web-app",
    "utils",
    "vault",
    "vm",
    "vpc-service-controls",
    "vpn"
]

for repo in repos:
    cmd = f"git clone {base_url}{repo}.git"
    sleep(1)
    try:
        subprocess.run(cmd, check=True, shell=True)
    except subprocess.CalledProcessError as e:
        print(f"\n\nFailed to clone {repo}. Error: {e}\n\n")

print("\n\nSuccessfully created terraform-google-modules.")