from langchain.chains.query_constructor.base import AttributeInfo

metadata_field_info = [
    AttributeInfo(
        name="sub_instance",
        description=
        "Specifies the exact variant or configuration of the instance that the Terraform code represents. This allows for precise identification of Terraform files based on specific implementations, such as a MySQL version for a Cloud SQL instance, enabling targeted retrieval of code.",
        type="string",
    ),
    AttributeInfo(
        name="product",
        description=
        "Identifies the broader GCP product category to which an instance belongs. For example, a Compute Engine VM or a Cloud SQL database would fall under 'compute' and 'sql' resources, respectively. This categorization facilitates the organization and search of Terraform files within the context of GCP products.",
        type="string",
    ),
    AttributeInfo(
        name="instance",
        description=
        "Denotes the specific instance within a GCP product that the Terraform code is designed to provision or manage. This could refer to a particular VM, database, or storage bucket, among others. The instance name aids in pinpointing Terraform files that apply to particular GCP service instances.",
        type="string",
    ),
    AttributeInfo(
        name="folder_type",
        description="""Modules folder_type:
This directory contains Terraform modules, which are pre-packaged configurations for specific use cases. Each module comprises resource and module blocks that encapsulate standard configurations for GCP products or functionalities. These modules are designed for reuse across different parts of the project or in other projects, promoting efficient and scalable infrastructure setups.

Examples folder_type:
The examples directory showcases how to use the Terraform modules from the modules directory in practical deployments. It includes sample Terraform configurations that reference and instantiate the modules, providing clear, real-world scenarios of module application. This directory is instrumental in demonstrating the modules' utility and easing their adoption by offering ready-to-use examples. """,
        type="string",
    ),
    AttributeInfo(
        name="type",
        description=
        """In a Terraform project aimed at deploying and managing resources on the Google Cloud Platform (GCP), three critical files play unique roles in ensuring the configuration's flexibility, clarity, and operational efficiency. These files—`variables.tf`, `main.tf`, and `outputs.tf`—each serve distinct purposes within the Terraform infrastructure as code (IaC) framework.

Variables.tf:

The `variables.tf` file is fundamental for defining and organizing variables to customize infrastructure deployments across various environments. Each variable is declared with a name, type, description, and optionally, a default value. This structure not only aids in making Terraform configurations modular and reusable but also enhances the maintainability of the code. Variables range from simple placeholders (e.g., project IDs, geographical locations) to complex structures for detailed resource definitions, embodying the principles of IaC by promoting a systematic and customizable approach to cloud resource deployment.

Main.tf:

At the core of a Terraform project, the `main.tf` file orchestrates the deployment of GCP resources. It integrates:

- **Local Variables (`locals`)** to centralize configurations, reducing repetition and enhancing configuration clarity.
- **Resource Blocks** to define the GCP resources to be managed or provisioned, including IAM roles and storage buckets.
- **Modules** to encapsulate and reuse configurations for efficient resource management.
- **Data Sources (`data`)** to incorporate data from GCP or external sources for informed configuration steps.
- **IAM and Permissions** to detail the setup for service accounts and specify roles for secure access management.

This file exemplifies the declarative nature of IaC, showcasing Terraform's capability to manage a diverse array of resources on GCP through a structured and scalable configuration.

Outputs.tf:

The `outputs.tf` file is dedicated to defining output variables that relay crucial deployment information to the user. These outputs highlight essential details such as resource identifiers, names, descriptions, and project-specific information, bridging the gap between complex configurations and actionable insights. By making critical deployment information accessible, the outputs.tf file not only enhances the transparency of cloud resources but also supports further automation, integration, and management tasks, emphasizing the importance of information accessibility in IaC practices.

README.md:

The README.md file serves as the project's documentation hub, containing critical information on how to use the Terraform product, module, or example. It outlines expected inputs, outputs, dependencies, requirements, and use cases, offering a comprehensive guide to navigating and utilizing the Terraform configuration effectively. This file ensures that users have a clear understanding of the project's scope, functionalities, and operational requirements, making it an indispensable resource for successful deployment.
Together, these files provide a solid framework for managing infrastructure on GCP with Terraform, leveraging the full potential of IaC to deliver adaptable, scalable, and efficiently managed cloud resources, complemented by thorough documentation for user guidance and project clarity.

Together, these files constitute a robust framework for managing infrastructure on GCP with Terraform, leveraging the strengths of IaC to deliver adaptable, scalable, and efficient cloud resource management. """,
        type="string",
    ),
]
