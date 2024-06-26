# Cloudweaver Databases

This folder contains the two primary Cloudweaver databases (raw text documentation and Terraform code samples) that our model will use as context.

# Contents
## code folder
The code database contains Terraform code samples pertaining to a collection of crucial Google Cloud Platform products. The expected architecture is as follows:

Within a given product folder or subdirectory, these objects are likely to exist:

**main.tf:**

- The main.tf file contains a collection of the basic resource blocks that are used to interact with its associated GCP product, module, or example via Terraform. This file may be long, contain resources for several different use cases, and have other miscellaneous Terraform blocks such as locals and data.

**varibles.tf:**

- The variables.tf file contains Terraform variable blocks which are used by other Terraform files within the same directory. Each variable has a name, a type, a description of what the variable does, and often a default value. This file is useful to understand the different configuration options for a given product, module, or example.

**outputs.tf:**

- The outputs.tf file contains Terraform output blocks which expose relevant deployment information to the user. This often includes information such as instance IDs, regions, zones, external IP addresses, and more. This file is useful for understanding how the user might interact with the deployment.

**README.md:**

- The README.md file contains important documentation for how use a given Terraform product, module, or example directory. This file includes information such as expected inputs, outputs, dependencies, requirements, and use cases.

**modules (directory):**

- The modules directory contains pre-packaged use cases for a given product, often expressed as a collection of resource and module blocks. These Terraform modules can then be referenced by module blocks within the examples directory.

**examples (directory):**

- The examples directory contains sample deploymens and Terraform module blocks which often reference associated modules from the modules directory. These examples showcase the easiest way to make use of a given Terraform module.

(Note: outputs.tf and the "modules" directory may not always exist).

## docs folder

This folder will contain documentation and example products for our model to reference during project generation. It is not yet implemented.

## scripting folder

This folder contains database metadata and the scripts required to regenerate the database locally.