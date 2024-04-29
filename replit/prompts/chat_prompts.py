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
  Given the confirmed architecture, suggest potential improvements that could enhance the project's efficiency, scalability, or reliability.

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

  Please provide the output in a JSON format with two keys: 'corrected_terraform_code' and 'linting_summary'. The 'corrected_terraform_code' key should contain the formatted Terraform code enclosed in triple backticks for better readability. The 'linting_summary' should provide a markdown-formatted summary of the changes made, including headers and bullet points to outline corrections and important notes. Each key's content should be clear and easy to follow, making it straightforward for developers to understand the corrections and their implications on the code.

  Existing Terraform Code:
  {existing_terraform_code}

  Linter Feedback (`tflint` Output):
  {tflint_terraform_feedback}

  Corrected Terraform Code:

  """
