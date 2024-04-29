from functions.chat_service import generate_architecture_func, revise_architecture_func, generate_improvements_func, generate_terraform_func
from flask import Flask, render_template, request, jsonify
from utils.markdown_functions import format_to_markdown

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

  return jsonify({
      'response':
      f"Architecture generated based on feedback.: {revised_architecture}",
      'prompt': "Do you confirm this architecture?",
      'nextState': 'awaiting_architecture_confirmation',
      'architecture': revised_architecture,
      'feedback': feedback
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
        'prompt': "Generating terraform code...",
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
  return jsonify({
      'response': f"Terraform code generated: {full_output}",
      'prompt': "Do you confirm this Terraform code?",
      'nextState': 'awaiting_terraform_confirmation',
      'terraformCode': full_output
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
    return jsonify({
        'response': "Terraform code confirmed",
        'prompt': "Would you like to download the Terraform code?",
        'nextState': 'offer_download',
        'terraformCode': data['terraformCode']
    })
  elif data['message'].lower() == 'no':
    return jsonify({
        'response': "Please provide feedback for terraform code.",
        'nextState': 'collecting_feedback',
        'architecture': data['architecture'],
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
        'nextState': 'Completed'
    })


if __name__ == '__main__':
  app.run(debug=True)
