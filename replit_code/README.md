# Cloudweaver Replit

This folder contains the replit environment for CloudWeaver

# Contents

## Config Folder

This folder contains the configuration for the db, primarily the metadata_attributes.

**db_config.py**

- Contains these metadata attributes

## Data folder

Contains the pickle file for the database and chroma db of this pickle file. Of which are used for the vector stores

Also contains the file for cleaning the data.

**data_cleaner.py**

## Functions folder

**chat_service.py**

- Contains the logic behind the chat service. How the frontend interacts with the backend. Aswell as how the RAG design is integrated into the backend.

## Linter folder

Contains the linter for terraform code, will be used to check the terraform output

**tflint**

## Models folder

Contains the functions for initializing the models, specifically both gemini and the contents of the retriever

**chat_model.py**

## Prompts folder

Contains the prompts that will be used in all of the chains, specifically pertaining towards the Architecture, Improvements, Revise Architecture, Terraform, Revise Terraform.

**chat_prompts.py**

## Static

Contains the assets, scripts and styles for CloudWeaver

### Assets

Contains all of the assets for CloudWeaver specifically PNG files

# Scripts

Contains **script.js** which contains the logic for the frontend

# Styles

Contains all of the styles for CloudWeaver in **style.css**

## Templates

Contains **chat.html** which is the frontend view for the program

## Utils

Contains all of the helpers for the programs

**initializers.py**

- Contains the code for initializing the models and other programs that require initializers

**markdown_functions.py**

- Contains the code for making the output into the markdown form

**main.py**

- Contains all of the routes for the program

# How to start this program

You can start this program by simply copying it into replit.

You will need to add a gemini API-Key.

Add this to secrets, and name it GOOGLE_API_KEY.

You can geerate a key here...

https://ai.google.dev/
