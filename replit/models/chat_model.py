from langchain_core.messages import HumanMessage
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_community.vectorstores import Chroma
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_community.vectorstores.utils import filter_complex_metadata

def initialize_model():
  try:
    return ChatGoogleGenerativeAI(model="gemini-pro",
                                  temperature=0.7,
                                  convert_system_mesasge_to_human=True)
  except Exception as e:
    raise RuntimeError(f"Failed to initialize model: {e}")


def initialize_docEmbeddings():
  try:
    return GoogleGenerativeAIEmbeddings(model="models/embedding-001",
                                        task_type="retrieval_document")
  except Exception as e:
    raise RuntimeError(f"Failed to initialize document embeddings: {e}")