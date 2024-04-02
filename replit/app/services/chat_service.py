#app/services/chat_service.py
from flask import request, jsonify
from ..config.config import Config
import os
from langchain_core.messages import HumanMessage
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnableParallel, RunnablePassthrough
from flask_socketio import send, emit


def initialize_model():
  try:
    return ChatGoogleGenerativeAI(model="gemini-pro", temperature=0.7)
  except Exception as e:
    raise RuntimeError(f"Failed to initialize model: {e}")


model = initialize_model()


def test_ai():
  try:
    # Retrieve the message from query parameters
    prompt = request.args.get('msg', 'Hello AI, how are you today?')
    output = model.invoke(prompt)
    response_text = output.text if hasattr(output, 'text') else str(output)
    return jsonify({"success": True, "response": response_text}), 200
  except Exception as e:
    print(e)
    return jsonify({
        "success": False,
        "error": "An unexpected error occurred."
    }), 500

# def chat_service_func_test(message):
#     if 'state' not in session:
#         session['state'] = 'collecting_project_description'
#         emit('message', 'Please describe your project.')
#     elif session['state'] == 'collecting_project_description':
#         session['project_description'] = message['text']
#         session['state'] = 'confirming_architecture'
#         architecture = generate_architecture(session['project_description'])  # Placeholder function
#         emit('message', f'Generated Architecture: {architecture}. Do you confirm this architecture? (yes/no)')
#     elif session['state'] == 'confirming_architecture' and message['text'].lower() == 'yes':
#         session['state'] = 'generating_terraform_code'
#         terraform_code = generate_terraform_code(architecture)  # Placeholder function
#         emit('message', f'Generated Terraform Code: {terraform_code}. Is this OK? (yes/no)')

def chat_service_func():
  # Define the initial prompt template for generating project architecture
  architecture_prompt_template = """Given the project description below, generate an initial architecture outline suitable for GCP using Terraform. Keep it concise and to the point.
  
  Project Description:
  {project_description}
  
  User Architecture Feedback:
  {user_architecture_feedback}
  
  Initial Architecture Outline:"""
  
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
  
  Existing Terraform Code:
  {{existing_terraform_code}}
  
  User Feedback:
  {{user_terraform_feedback}}
  
  Your Terraform Code:
  """
  
  
  # Custom prompt templates
  architecture_prompt = PromptTemplate.from_template(
      architecture_prompt_template)
  terraform_code_prompt = PromptTemplate.from_template(
      terraform_prompt_template)
  
  # Define the interaction chain for architecture generation and confirmation
  architecture_chain = ({
      "project_description": RunnablePassthrough(),
      "user_architecture_feedback": RunnablePassthrough()
  }
      | architecture_prompt
      | model
      | StrOutputParser())
  
  # Define the interaction chain for Terraform code generation
  terraform_code_chain = ({
      "confirmed_architecture": RunnablePassthrough(),
      "existing_terraform_code": RunnablePassthrough(),
      "user_terraform_feedback": RunnablePassthrough()
  }
      | terraform_code_prompt
      | model
      | StrOutputParser())
  
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
  
  project_description = input("Enter the project description: ")
  
  user_architecture_feedback = "Initial Feedback (None)"
  user_terraform_feedback = "Initial Feedback (None)"
  existing_terraform_code = ""
  
  architecture = None
  while not architecture:
    try:
      architecture = architecture_chain.invoke({
          "project_description": project_description,
          "user_architecture_feedback": "user_architecture_feedback"
      })
    except Exception as e:
      print("Error:", e)
      break
  
    print("Generated Architecture: ", architecture)
    user_confirmation = input("User confirms this architecture? (yes/no): ")
    if user_confirmation.lower() == 'yes':
      break
    else:
      user_architecture_feedback = input("Please describe the issues you have with the architecture: ")
  
  improvements = improvement_chain.invoke(
    {"confirmed_architecture": architecture})
  
  # Display the suggested improvements to the user
  print("Suggested Improvements: ", improvements)
  user_confirmation = input(
    "Would you like to incorporate suggested improvements? (yes/no): ")
  
  if user_confirmation.lower() == 'yes':
      # Update the architecture with the improvements
      architecture += "\n\nIncorporated Improvements:\n" + improvements
  
  # print()
  # print(architecture)
  terraform_code_correct = False
  terraform_code_generated = None
  while terraform_code_correct == False:
    print("Architecture: ", architecture)
    try:
      terraform_code_generated = terraform_code_chain.invoke({
          "confirmed_architecture": architecture,
          "existing_terraform_code": existing_terraform_code,
          "user_terraform_feedback": user_terraform_feedback
      })
    except Exception as e:
      print("Error:", e)
      break
  
    print("Generated Terraform Code: ", terraform_code_generated)
    user_confirmed_terraform_code = input("User confirms this Terraform code? (yes/no): ")
    if user_confirmed_terraform_code.lower() == 'yes':
      terraform_code_correct = True
    else:
        existing_terraform_code = terraform_code_generated
        user_terraform_feedback = input("What is wrong with the code? ") 
  
  if terraform_code_correct:
    filename = "confirmed_terraform_code.hcl"
    with open(filename, 'w') as file:
      file.write(terraform_code_generated)
      print(f"Terraform code has been written to {filename}")
  
  return jsonify({
      "success": True,
      "response": "Chaining functionality completed successfully. Check terraform_code.hcl for the generated Terraform code."
  }), 200
  