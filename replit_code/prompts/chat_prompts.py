def build_architecture_prompt():
  return """Given the detailed project description and user feedback below, generate an optimized initial architecture outline suitable for deployment on Google Cloud Platform (GCP) using Terraform. Aim for a design that balances performance, cost, security, and scalability. Include considerations for key GCP services, data storage options, compute resources, networking setup, and any specific security policies or compliance requirements mentioned. Suggest potential areas for cost optimization without compromising on performance. Address any concerns or modifications suggested in the user feedback explicitly, proposing how the architecture can be adjusted to meet these insights.

  Project Description:
  {project_description}

  To ensure a comprehensive understanding, please include the following in the Initial Architecture Outline:
  1. A list of recommended GCP services and tools, with brief explanations for their selection.
  2. An overview of the data flow and storage strategy, considering data volume, velocity, and variety.
  3. Proposed networking and security configurations, including any VPCs, subnets, firewalls, and identity and access management (IAM) roles.
  4. Strategies for monitoring, logging, and alerting to ensure system health and performance.
  5. Any initial Terraform configurations or module recommendations that can jump-start the deployment process.
  6. Suggestions for handling scalability, including any auto-scaling or load balancing configurations.
  7. Considerations for disaster recovery and data backup strategies to ensure business continuity.

  Feel free to request additional information or clarification if the project description or user feedback lacks specific details necessary for a well-rounded proposal."""


def build_revised_architecture_prompt():
  return """
  If you are given pre-existing architecture of which isn't '', then that means that you have already generated architecture but were given feedback. If this is the case, then please provide improvements to the architecture based on the feedback. Thus, this means that it is your responsibility to revise the architecture, according to the feedback given. If you are only asked to add to the architecture that you've already created, then only add DO NOT REMOVE ANYTHING. If you are asked to modify anything, please modify accordingly. If you are asked to remove anything, please remove accordingly.

  Initial Architecture:
  {initial_architecture}

  User Architecture Feedback:
  {user_architecture_feedback}

  Revised Architecture Outline:"""


def build_improvements_prompt():
  return """
  Given the confirmed architecture, suggest detailed improvements that could enhance the project's efficiency, scalability, reliability, or cost-effectiveness. Specify how each suggestion would modify or improve the existing architecture, including potential integration with current tools and technologies.

  Confirmed Architecture Outline:
  {confirmed_architecture}

  Suggested Improvements:"""


def build_terraform_prompt():
  return """
  Given the confirmed architecture outline detailed below, your task is to generate comprehensive Terraform code suitable for deploying the specified project on Google Cloud Platform (GCP). The generated code should accurately reflect the unique infrastructure requirements outlined, emphasizing scalability, security, and cost-efficiency. Utilize the retriever's library of Terraform files — categorized by product and resource, with accompanying README files — as a foundation for your code. This library will serve as a valuable resource for identifying pre-existing configurations that align with the project's needs, thereby streamlining the code development process.

  When constructing your Terraform configurations, ensure they are tailored to the project's specific requirements by:
  1. Selecting appropriate GCP services and configuring them to form a secure, scalable, and cost-effective infrastructure.
  2. Incorporating a Google Compute Engine instance with specifications that support the application's performance needs while optimizing costs.
  3. Establishing a comprehensive networking setup including VPCs, subnets, and firewall rules to ensure a secure operational environment.
  4. Defining necessary IAM roles and policies for secure access management across GCP services.
  5. Integrating storage solutions that accommodate the application's data handling requirements.
  6. Planning for future growth with scalable solutions like Load Balancing and autoscaling.
  7. Embedding monitoring, logging, and alerting mechanisms to facilitate efficient infrastructure management.
  8. Structuring the code for modularity, reusability, and clarity, incorporating documentation where beneficial.

  Additionally, address any user feedback provided to refine and adjust the Terraform code, focusing on improvements in security, scalability, and efficiency. Your final output should not only align with the confirmed architecture outline but also adhere to best practices in cloud infrastructure design.

  Confirmed Architecture Outline:
  {confirmed_architecture}

  Your Terraform Code:
  """


def build_correct_terraform_prompt():
  return """
  Task Description:
  You will be given the output of `tflint`, a Terraform linter, and a corresponding Terraform script. Your task is to interpret this output, identify issues flagged by the linter, and apply corrections to the Terraform script accordingly. Follow these steps to ensure accuracy and compliance with Terraform standards.

  Steps to Follow:

  1. Review `tflint` Output:
     - Start by examining the `tflint` output provided. It will detail specific issues including the type of issue, its severity, and the exact location within the Terraform script (file and line number).

  2. Analyze Each Issue:
     - For every issue listed by `tflint`, evaluate the context and the code surrounding the flagged location to understand why it was marked. This includes syntax errors, deprecated elements, and best practice deviations.

  3. Apply Corrections:
     - Direct Corrections: Adjust the script to resolve straightforward issues such as syntax errors or incorrect attribute names according to Terraform’s documentation.
     - Best Practices: Update the script to replace hard-coded values with variables, add missing descriptions, or improve resource configurations as recommended by `tflint`.

  4. Document Changes:
     - Add comments within the script next to each change. Briefly describe why the change was made to help with future maintenance and understanding.

  5. Validation:
     - After implementing the changes, check the overall script to ensure that it still aligns with Terraform's syntax and best practices and that no new issues have been introduced.

  6. Output the Revised Script:
     - Provide the corrected Terraform script, highlighting the changes made. Also, include a summary of each correction addressing the specific issues identified by `tflint`.

  Objective:
  The goal is to enhance the quality and compliance of the Terraform script based on the `tflint` feedback, making precise corrections without altering the script’s fundamental functionality or intent.

  Please provide the output in a markdown format with two keys: ###Terraform_Code### and ###Linting_Summary###. The ###Terraform_Code### key should contain the formatted Terraform code enclosed in triple backticks for better readability. The ###Linting_Summary### should provide a markdown-formatted summary of the changes made, including headers and bullet points to outline corrections and important notes. Each key's content should be clear and easy to follow, making it straightforward for developers to understand the corrections and their implications on the code.

Please provide the response in Markdown format. Ensure that all text formatting (like headings, lists, and links) follows Markdown syntax rules. Use appropriate Markdown elements for headings (`#`, `##`), lists (`-` or `*` for unordered and `1.`, `2.`, etc. for ordered), code blocks (`` ``` ``), and hyperlinks (`[link text](URL)`). If you include tables, format them properly using pipes (`|`) and dashes (`-`). Make sure the response is clear, structured, and easy to read as a Markdown document.


  Existing Terraform Code:
  {existing_terraform_code}

  Linter Feedback (`tflint` Output):
  {tflint_terraform_feedback}

  Corrected Terraform Code:

  """


def build_revise_terraform_code_prompt():
  return """
    Given the user feedback on the previously generated Terraform code and the confirmed architecture outline, your task is to revise the Terraform code to align it more closely with the project's requirements on Google Cloud Platform (GCP). Focus on making adjustments that address the specific concerns raised in the feedback, such as enhancing security, scalability, or cost-efficiency. However, if the confirmed architecture is None or '', then you are asked to revise the Terraform code according to the user feedback.
    
    When revising your Terraform configurations:
    1. Review the user feedback carefully and identify areas of the code requiring adjustments, additions, or removals.
    2. Modify existing configurations to enhance performance, security, and cost-effectiveness, directly addressing the feedback points.
    3. Add new components or resources as required by the feedback to meet additional or altered requirements.
    4. Remove any configurations or resources specifically pointed out in the feedback as unnecessary or suboptimal.
    5. Ensure that all changes maintain or enhance the integration and functionality of the overall infrastructure.
    6. Enhance code modularity, readability, and reusability, and update documentation to reflect changes.
  
    Consider the following as you revise:
    - Specific feedback that targets particular sections or configurations of the Terraform code.
    - The need to balance revisions with the overall goals of the confirmed architecture outline.
    - Best practices in Terraform coding and Google Cloud Platform deployment to ensure that the revised code remains robust and efficient.

    Previous Terraform Code:
    {terraform_code}

    Confirmed Architecture Outline:
    {confirmed_architecture}
    
    User Feedback on Terraform Code:
    {user_feedback}
  
    Revised Terraform Code:"""

def build_final_prompt():
  return """### 1. Pre-requisites
  Before you start, ensure you have the following:
  - A Google Cloud Platform account.
  - Billing enabled on your GCP account.
  - Access to create projects and manage billing accounts in GCP.
  
  ### 2. Install Required Tools
  You will need to install the following tools:
  - **Google Cloud SDK**: Download and install the Google Cloud SDK from [here](https://cloud.google.com/sdk/docs/install).
  - **Terraform**: Download and install Terraform from [here](https://www.terraform.io/downloads.html).
  
  ### 3. Configure the Google Cloud SDK
  1. Open a terminal or command prompt.
  2. Initialize the gcloud tool by running:
     ```
     gcloud init
     ```
  3. Follow the on-screen instructions to authenticate your Google account and select your default project.
  
  ### 4. Set Up Terraform Credentials
  1. Create a service account in your Google Cloud project:
     - Go to the IAM & Admin page in the Google Cloud Console.
     - Create a new service account with the necessary roles (at least "Editor" role or more specific roles depending on your Terraform configuration).
  2. Create and download a JSON key file for this service account.
  3. Set the environment variable to authenticate Terraform with Google Cloud:
     ```bash
     export GOOGLE_APPLICATION_CREDENTIALS="[PATH-TO-YOUR-SERVICE-ACCOUNT-KEY-FILE]"
     ```
  
  ### 5. Prepare the Terraform File
  - Ensure the Terraform file (e.g., `main.tf`) is configured correctly for your project needs. This file should define your GCP resources.
  
  ### 6. Initialize Terraform
  1. Navigate to the directory containing your Terraform file.
  2. Run the following command to initialize Terraform and download the required providers:
     ```bash
     terraform init
     ```
  
  ### 7. Plan the Terraform Deployment
  - Execute the following command to see what resources Terraform will create/modify:
    ```bash
    terraform plan
    ```
  
  ### 8. Apply the Terraform Configuration
  - To apply the Terraform configuration and create the resources in GCP, run:
    ```bash
    terraform apply
    ```
  - Confirm the action by typing `yes` when prompted.
  
  ### 9. Verify Deployment
  - Go to the Google Cloud Console and verify that the resources have been created as defined in your Terraform configuration.
  
  ### 10. Manage Your Infrastructure
  - Use Terraform to manage the lifecycle of your resources. To update your infrastructure, modify the Terraform files and re-run `terraform apply`.
  - To destroy the Terraform-managed infrastructure, if needed, use:
    ```bash
    terraform destroy
    ```
  - Confirm the action by typing `yes` when prompted.
  
  By following these steps, you should be able to deploy and manage a GCP project using a Terraform configuration file. Ensure to manage your Terraform state file securely, especially if you are working in a team or on significant projects."""