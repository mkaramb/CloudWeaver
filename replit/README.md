# Cloudweaver Replit

This folder contains the contents contained in the replit environment. These files are not runnable through a vscode environment, and are meant to be used in the Replit environment. To run this code, please place all contents of this folder into Replit. You will need to install dependencies that will be provided below. Upon installing the dependencies, you can begin running the code by clicking the green button found on Replit.

# Contents

## app folder

The app folder contains the files that encompass the interactions between the backend and the frontend.

## config folder

**config.py**

- The config file contains variables used for accessing the secret key and initializating it for use in backend logic. Specifically in relation to Gemini.

## routes folder

**chat_routes.py**

- Contains the routes that will connect chat_service.py (the logic behind interactions with the chaining) to the frontend.

**main_routes.py:**

- The route for the home page

## services folder

**chat_service.py**

- The backend logic, contains methods for connecting to the llm and the chaining

## templates folder

- Contains templates that are currently unused. Will be used for the frontend

**main.py**

- Starts the initialization of the server
