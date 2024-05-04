# File for loading and filtering documents

import pickle


def load_documents(file_path):
  with open(file_path, 'rb') as file:
    documents = pickle.load(file)
    print('Documents loaded successfully...')
  return documents


def filter_documents(documents):
  print('Cleaning documents...')
  return [
      doc for doc in documents
      if doc.page_content and doc.page_content.strip()
  ]
