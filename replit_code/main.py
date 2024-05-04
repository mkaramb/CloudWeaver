from functions.chat_service import generate_architecture_func, revise_architecture_func, generate_improvements_func, generate_terraform_func, revise_terraform_code
from flask import Flask, render_template, request, jsonify, redirect, url_for, Response
from utils.markdown_functions import format_markdown, format_to_markdown
from prompts.chat_prompts import build_final_prompt

app = Flask(__name__)


@app.route('/')
def index():
  return render_template(
      'chat.html', initial_prompt="Please provide your project description.")


# Deals with architecure routes
@app.route('/generate_architecture', methods=['POST'])
def generate_architecture_route():
  data = request.get_json()
  architecture = generate_architecture_func(data['message'])
  architecture_markdown = format_to_markdown(architecture)
  return jsonify({
      'response': f"{architecture_markdown}",
      'prompt': "Do you confirm this architecture?",
      'nextState': 'awaiting_architecture_confirmation',
      'architecture': architecture
  })


@app.route('/confirm_architecture', methods=['POST'])
def confirm_architecture():
  data = request.get_json()
  architecture = data.get('architecture', '')
  if data['message'].lower() == 'yes':
    return jsonify({
        'response': "",
        'prompt': "Would you like me to generate improvements?",
        'nextState': 'generate_improvements_confirmation',
        'architecture': architecture
    })
  elif data['message'].lower() == 'no':
    return jsonify({
        'response': "Please provide feedback on the architecture.",
        'prompt': "Enter your feedback:",
        'nextState': 'collecting_feedback',
        'architecture': architecture
    })
  else:
    return jsonify({
        'response': "Invalid input. Please enter 'yes' or 'no'.",
        'prompt': "Do you confirm this architecture?",
        'nextState': 'awaiting_architecture_confirmation',
        'architecture': architecture
    })


@app.route('/process_feedback', methods=['POST'])
def process_feedback():
  data = request.get_json()
  architecture = data.get('architecture')
  feedback = data['message']
  if not architecture or not feedback:
    return jsonify({'error':
                    'Architecture and feedback must be provided.'}), 400
  revised_architecture = revise_architecture_func(architecture, feedback)
  revised_architecture_markdown = format_to_markdown(revised_architecture)
  return jsonify({
      'response': f"{revised_architecture_markdown}",
      'prompt': "Do you confirm this architecture?",
      'nextState': 'awaiting_architecture_confirmation',
      'architecture': revised_architecture,
      'feedback': feedback
  })


@app.route('/process_terraform_feedback', methods=['POST'])
def process_terraform_feedback():
  data = request.get_json()
  confirmed_architecture = data.get('architecture', 'None')
  previous_terraform_code = data.get('terraformCode')
  terraformFeedback = data['message']
  if not previous_terraform_code or not terraformFeedback:
    return jsonify({'error':
                    'Terraform code and feedback must be provided.'}), 400
  revised_terraform = revise_terraform_code(confirmed_architecture,
                                            previous_terraform_code,
                                            terraformFeedback)
  cleaned_output = format_markdown(revised_terraform)
  return jsonify({
      'response': f"{cleaned_output}",
      'prompt': "Do you confirm this revised terraform code?",
      'nextState': 'awaiting_terraform_confirmation',
      'terraformCode': revised_terraform,
      'terraformFeedback': terraformFeedback
  })


#Improvement routes
@app.route('/generate_improvements_confirmation', methods=['POST'])
def generate_improvements_confirmation():
  data = request.get_json()
  if data['message'].lower() == 'yes':
    return jsonify({
        'response': "",
        'prompt': "Generating improvements...",
        'nextState': 'generate_improvements'
    })
  elif data['message'].lower() == 'no':
    return jsonify({
        'response': "",
        'prompt': "Would you like me to generate terraform?",
        'nextState': 'generate_terraform_code'
    })
  else:
    return jsonify({
        'response': "Invalid input. Please enter 'yes' or 'no'.",
        'nextState': 'generate_improvements_confirmation'
    })


@app.route('/generate_improvements', methods=['POST'])
def generate_improvements():
  data = request.get_json()
  improvements = generate_improvements_func(data['architecture'])
  improvements_markdown = format_to_markdown(improvements)
  return jsonify({
      'response': f"{improvements_markdown}",
      'prompt': "Do you confirm these improvements?",
      'nextState': 'confirm_improvements',
      'improvements': improvements
  })


@app.route('/confirm_improvements', methods=['POST'])
def confirm_improvements():
  data = request.get_json()
  if data['message'].lower() == 'yes':
    return jsonify({
        'response': "",
        'prompt': "Would you like me to generate terraform code?",
        'nextState': 'generate_terraform_code',
        'architecture': data['architecture']
    })
  elif data['message'].lower() == 'no':
    return jsonify({
        'response': "Please provide feedback for improvements.",
        'nextState': 'collecting_feedback',
        'architecture': data['architecture'],
    })
  else:
    return jsonify({
        'response': "Invalid input. Please enter 'yes' or 'no'.",
        'nextState': 'awaiting_improvements_confirmation'
    })


# Terraform routes
@app.route('/generate_terraform', methods=['POST'])
def generate_terraform():
  data = request.get_json()
  improvements = data.get('improvements', 'None')
  full_output = generate_terraform_func(data['architecture'], improvements)
  cleaned_output = format_markdown(full_output)
  print(full_output)
  return jsonify({
      'response': f"{cleaned_output}",
      'prompt': "Do you confirm this Terraform code?",
      'nextState': 'awaiting_terraform_confirmation',
      'terraformCode': cleaned_output
  })


@app.route('/confirm_terraform_code', methods=['POST'])
def confirm_terraform_code():
  data = request.get_json()
  if 'terraformCode' not in data:
    return jsonify({
        'response': "Error: Terraform code missing.",
        'nextState': 'awaiting_terraform_confirmation'
    }), 400  # Return a 400 Bad Request if terraformCode is missing

  if data['message'].lower() == 'yes':
    print_statement = build_final_prompt()
    final_output = format_to_markdown(print_statement)
    return jsonify({
        'response': f"{final_output}",
        'nextState': 'offer_download',
        'terraformCode': data['terraformCode']
    })
  elif data['message'].lower() == 'no':
    return jsonify({
        'response': "Please provide feedback for terraform code.",
        'nextState': 'collecting_terraform_feedback',
        'architecture': data['architecture'],
        'terraformCode': data['terraformCode']
    })
  else:
    return jsonify({
        'response': "Invalid input. Please enter 'yes' or 'no'.",
        'nextState': 'awaiting_terraform_confirmation'
    })


@app.route('/download_terraform', methods=['POST'])
def download_terraform():
  data = request.get_json()
  if data['message'].lower() == 'yes':
    terraform_code = data['terraformCode']
    from flask import Response
    filename = "terraform_configuration.tf"
    return Response(terraform_code,
                    headers={
                        "Content-Disposition":
                        f"attachment; filename={filename}",
                        "Content-type": "text/plain"
                    })
  else:
    return jsonify({
        'response': "Download cancelled.",
        'nextState': "Completed"
    })


if __name__ == '__main__':
  app.run(debug=True)
