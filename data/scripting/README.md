# Database Generation Scripts

This folder contains the two Python scripts to generate the Cloudweaver database from scratch, as well as script logs and metadata files pertaining to the Terraform code database.

# Setup:

1. Download the Python scripts tf_fetch.py and tf_clean_merge.py
2. Run tf_fetch.py in your desired workspace
-  This script will create its own directory for the database named terraform-google-modules.
- Note: This script downloads from GitHub using SSH. If you do not have SSH set up, please uncomment the HTML command instead.
3. Run tf_clean_merge.py in the same directory
- This will consolidate and reorganize the newly created terraform-google-modules directory to match our database architecture.