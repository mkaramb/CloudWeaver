from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from config.db_config import metadata_field_info
from prompts.chat_prompts import build_architecture_prompt, build_revised_architecture_prompt, build_improvements_prompt, build_terraform_prompt, build_correct_terraform_prompt, build_revise_terraform_code_prompt
from utils.initializers import load_and_clean_documents, initialize_vector_store, initialize_model, initialize_retriever

import subprocess
import tempfile
import os

cleaned_documents = load_and_clean_documents()
model = initialize_model()
vectorstore = initialize_vector_store()

document_content_description = "Examples of different components of GCP terraform instances and modules along with readmes describing them."

retriever = initialize_retriever(model, vectorstore,
                                 document_content_description,
                                 metadata_field_info)


def generate_architecture_func(project_description):
  # Define the initial prompt template for generating project architecture
  architecture_prompt_template = build_architecture_prompt()

  # print("Got here")
  architecture_prompt = PromptTemplate.from_template(
      architecture_prompt_template)

  # Define the interaction chain for architecture generation and confirmation
  architecture_chain = ({
      "project_description": RunnablePassthrough(),
  }
                        | architecture_prompt
                        | model
                        | StrOutputParser())

  architecture = architecture_chain.invoke({
      "project_description":
      project_description,
  })
  return architecture


def revise_architecture_func(initial_architecture, user_architecture_feedback):
  # Define the prompt for generating new architecture based on feedback
  revise_architecture_prompt_template = build_revised_architecture_prompt()

  revise_architecture_prompt = PromptTemplate.from_template(
      revise_architecture_prompt_template)

  revise_architecture_chain = {
      "initial_architecture": RunnablePassthrough(),
      "user_architecture_feedback": RunnablePassthrough()
  } | revise_architecture_prompt | model | StrOutputParser()

  revised_architecture = revise_architecture_chain.invoke({
      "initial_architecture":
      initial_architecture,
      "user_architecture_feedback":
      user_architecture_feedback
  })
  return revised_architecture


def generate_improvements_func(confirmed_architecture):
  # Define the prompt template for suggesting improvements
  improvement_prompt_template = build_improvements_prompt()

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


# Terraform generation section
def generate_terraform_func(confirmed_architecture, improvements):
  terraform_prompt_template = build_terraform_prompt()
  confirmed_architecture += "\n\nIncorporated Improvements:\n" + improvements

  terraform_code_generated = generate_terraform_code(
      confirmed_architecture, terraform_prompt_template)

  linter_feedback = lint_terraform_code(terraform_code_generated)

  # if linter_feedback:
  #   print('Acquired linter feedback: ', linter_feedback)

  corrected_code = correct_terraform_code(terraform_code_generated,
                                          linter_feedback)
  return corrected_code


def generate_terraform_code(confirmed_architecture, prompt_template):
  terraform_code_prompt = PromptTemplate.from_template(prompt_template)
  terraform_code_chain = ({
      "context": retriever,
      "confirmed_architecture": RunnablePassthrough(),
  } | terraform_code_prompt | model | StrOutputParser())
  return terraform_code_chain.invoke(
      {"confirmed_architecture": confirmed_architecture})


def lint_terraform_code(code):
  clean_code = code.replace("```", "")
  # Use delete=False to prevent automatic deletion on file close
  with tempfile.NamedTemporaryFile(delete=False, suffix=".tf") as temp_file:
    temp_file_name = temp_file.name
    temp_file.write(clean_code.encode('utf-8'))
    temp_file.flush()  # Ensure all data is written to disk

  # Now run the linter on the file
  result = subprocess.run(
      ["/home/runner/CloudWeaverFlaskFix/linter/tflint", temp_file_name],
      capture_output=True,
      text=True)

  # After running the subprocess, manually delete the file
  os.unlink(temp_file_name)
  return result.stdout + "\n" + result.stderr


def correct_terraform_code(terraform_code_generated, linter_feedback):
  corrected_terraform_template = build_correct_terraform_prompt()
  # print('Got here 4')
  lint_prompt = PromptTemplate.from_template(
      corrected_terraform_template,
      additional_instructions=
      "Review the linter feedback closely and modify the Terraform script to address each specific issue reported. Ensure to add comments explaining each change for future reference."
  )

  finalized_code_chain = ({
      "context": retriever,
      "existing_terraform_code": RunnablePassthrough(),
      "tflint_terraform_feedback": RunnablePassthrough()
  }
                          | lint_prompt
                          | model
                          | StrOutputParser())

  finalized_code = finalized_code_chain.invoke({
      "existing_terraform_code":
      terraform_code_generated,
      "tflint_terraform_feedback":
      linter_feedback
  })

  formatted_code = finalized_code.replace("\\n", "\n")
  return formatted_code


def revise_terraform_code(terraform_code_generated, confirmed_architecture,
                          user_feedback):
  revise_terraform_template = build_revise_terraform_code_prompt()
  revise_terraform_prompt = PromptTemplate.from_template(
      revise_terraform_template)

  revise_terraform_chain = ({
      "context": retriever,
      "confirmed_architecture": RunnablePassthrough(),
      "user_feedback": RunnablePassthrough(),
      "terraform_code": RunnablePassthrough()
  } | revise_terraform_prompt | model | StrOutputParser())

  revised_code = revise_terraform_chain.invoke({
      "terraform_code":
      terraform_code_generated,
      "confirmed_architecture": confirmed_architecture,
      "user_feedback": user_feedback
  })

  linter_feedback = lint_terraform_code(revised_code)
  corrected_code = correct_terraform_code(revised_code, linter_feedback)

  return corrected_code
