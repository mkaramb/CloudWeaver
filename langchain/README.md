# LangChain Folder README

Welcome to the `langchain` folder of our RAG-enhanced Gemini LLM project for generating Terraform GCP project files. This directory is the core of our project, containing the Python notebooks that integrate LangChain with our data and custom retriever for generating accurate Terraform configurations. Here's an overview of what you'll find in this folder.

## Overview

The `langchain` folder contains Python notebooks and scripts that leverage the LangChain library to integrate our Terraform code database with a retrieval-augmented version of Google's Gemini LLM. This setup allows us to generate Terraform configurations for GCP projects by querying a database of Terraform documentation and code examples.

## Files Description

- **Custom Retriever File:** Implements a basic retriever connected to a LangChain chain and a database. This script demonstrates how to set up the environment for LangChain, mount a Google Drive for data access, read Terraform files, extract metadata, and initialize a retriever with Google's Generative AI model and Chroma vector store.

- **Database Processing File:** Focuses on extracting files from the database, assigning metadata, and organizing them into a structured format. It showcases the process of cloning a GitHub repository with Terraform code samples, navigating through its directory structure, reading the content of Terraform files, and generating a pickle file with metadata for further processing.

- **Chaining Updated File:** Provides the logic for a chat service function that interacts with users to refine project descriptions, suggest improvements, and generate Terraform code. It illustrates how to use LangChain to create interactive chains that incorporate user feedback, suggest architectural improvements, and ultimately produce ready-to-use Terraform configurations.

## Setup and Usage

1. **Environment Preparation:** Ensure you have a Google Colab or a local Python environment set up with access to Google Drive if you're using cloud storage for your data.

2. **Dependencies Installation:** Each file contains a block of code for installing necessary dependencies. Run these at the start of your notebook session to ensure all required libraries are available.

3. **Mounting Google Drive:** If your data is stored on Google Drive, follow the instructions in the notebooks to mount it and access your files.

4. **Data Reading and Processing:** Utilize the provided functions and templates to read Terraform documentation, extract useful metadata, and organize your data for retrieval.

5. **Retriever Initialization:** Configure the custom retriever by connecting it with your data source (e.g., a Chroma vector store) and setting up the Gemini LLM for processing queries.

6. **Chain Execution:** Follow the examples to execute LangChain chains, incorporating user input and feedback to generate Terraform configurations.
