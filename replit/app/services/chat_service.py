# services/chat_service.py

from langchain_core.messages import HumanMessage
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnableParallel, RunnablePassthrough

def generate_architecture(project_description):
  # Define the initial prompt template for generating project architecture
  architecture_prompt_template = """Given the project description below, generate an initial architecture outline suitable for GCP using Terraform. Keep it concise and to the point.

  Project Description:
  {project_description}

  User Architecture Feedback:
  {user_architecture_feedback}

  Initial Architecture Outline:"""

  architecture_prompt = PromptTemplate.from_template(
    architecture_prompt_template)

  # Define the interaction chain for architecture generation and confirmation
  architecture_chain = ({
      "project_description": RunnablePassthrough(),
      "user_architecture_feedback": RunnablePassthrough()
  }
      | architecture_prompt
      | model
      | StrOutputParser())

  user_architecture_feedback = "Initial Feedback (None)"
  
  architecture = architecture_chain.invoke({
        "project_description": project_description,
        "user_architecture_feedback": "user_architecture_feedback"
      })

  return architecture

def suggest_improvements(confirmed_architecture):
  # Define the prompt template for suggesting improvements
  improvement_prompt_template = """
  Given the confirmed architecture outline below, suggest potential improvements that could enhance the project's efficiency, scalability, or reliability.

  Confirmed Architecture Outline:
  {confirmed_architecture}

  Suggested Improvements:"""

  improvement_prompt = PromptTemplate.from_template(
    improvement_prompt_template)

  # Define the interaction chain for improvement suggestions
  improvement_chain = ({
    "confirmed_architecture": RunnablePassthrough()
  }
    | improvement_prompt
    | model
    | StrOutputParser())

  improvements = improvement_chain.invoke(
    {"confirmed_architecture": confirmed_architecture})

  return improvements

def generate_terraform_code(confirmed_architecture):
  # Define the prompt template for generating Terraform code based on confirmed architecture
  terraform_prompt_template = """
  Given the confirmed architecture outline below, generate the full Terraform code necessary to deploy the project on GCP. The generated code should reflect the unique requirements of the specified architecture, focusing on creating a scalable and secure infrastructure. Use the example below as a guide for the format and structure but develop your own resource configurations and names based on the project's needs. Your code should include a Compute Engine instance, appropriate networking setup, and any other resources deemed necessary for a basic web application.

  Note: The example is for illustration only. Please generate custom configurations based on the architecture outline.

  Example Terraform Code:
  resource "google_compute_instance" "default" {{
    name         = "example-instance"
    machine_type = "e2-medium"
    zone         = "us-central1-a"

    boot_disk {{
      initialize_params {{
        image = "debian-cloud/debian-9"
      }}
    }}

    network_interface {{
      network = "default"
      access_config {{}}
    }}
  }}

  Confirmed Architecture Outline:
  {{confirmed_architecture}}

  Your Terraform Code:
  """

  terraform_code_prompt = PromptTemplate.from_template(
    terraform_prompt_template)

  # Define the interaction chain for Terraform code generation
  terraform_code_chain = ({
      "confirmed_architecture": RunnablePassthrough(),
  }
      | terraform_code_prompt
      | model
      | StrOutputParser())


  terraform_code_generated = terraform_code_chain.invoke({
    "confirmed_architecture": confirmed_architecture,
  })
  return terraform_code_generated

