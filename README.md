# RAG-Enhanced Gemini LLM for Terraform GCP Project Generation

Welcome to the repository of our cutting-edge project, which leverages the power of RAG (Retrieval-Augmented Generation) enhancement over Google's Gemini Large Language Model (LLM), implemented via LangChain. This project focuses on generating Terraform configuration files specifically for Google Cloud Platform (GCP) projects, aiming to streamline and optimize cloud infrastructure deployment.

## Overview

Our project introduces a novel approach by integrating RAG with Gemini LLM to provide a more context-aware and data-informed generation of Terraform files for GCP. Utilizing LangChain, we've developed a workflow that not only extracts but also processes Terraform documentation directly from Google's Terraform GitHub repositories. This process enriches the model's context, enabling it to generate more accurate and efficient Terraform configurations.

### Project Structure

The repository is organized into several key folders, each serving a distinct purpose in the project's ecosystem:

- `data/`: Contains the code database used as context for the Gemini LLM model, including a comprehensive collection of Terraform documentation and metadata.
- `scripting/`: Describes the scalable method employed for extracting Terraform documentation from Google's official Terraform GitHub repositories.
- `langchain/`: Houses Python notebooks that perform data extraction from the `data` folder, feed this data into a self-querying retriever, and then incorporate this retriever into a processing chain.
- `replit/`: Contains the frontend code for deploying the model in a Replit environment, enabling users to interact with the model through a web interface.

### Detailed Folder Structure and Contents

#### `data/`

This folder acts as the backbone of the project, providing the necessary context and knowledge base for the RAG-enhanced Gemini LLM. It includes:

- Terraform documentation and metadata extracted from GitHub.
- A `README.md` file that offers an in-depth explanation of the contents and the methodology used for data collection and organization.

#### `scripting/`

This directory outlines the process for dynamically extracting Terraform documentation, ensuring the model has access to the latest information. It contains:

- Scripts for data extraction and processing.
- A `README.md` file detailing the scripts' functionality, usage, and the extraction process's scalability and efficiency.

#### `langchain/`

The LangChain integration is crucial for the project's functionality, providing the mechanisms for data retrieval and model augmentation. This folder includes:

- Python notebooks that demonstrate the step-by-step process of data extraction, retrieval augmentation, and chain implementation.
- A `README.md` file that describes the purpose of each notebook and guides users through the LangChain integration process.

#### `replit/`

To ensure accessibility and ease of use, we've included a Replit folder, which offers:

- Frontend code necessary for deploying the project in a Replit environment.
- A `README.md` file that explains how to set up and use the Replit interface for interacting with the project.

## Getting Started

To begin using this project for generating Terraform GCP project files, please follow the setup instructions provided in each folder's `README.md` file. These instructions will guide you through the process of data extraction, model preparation, and deployment.
