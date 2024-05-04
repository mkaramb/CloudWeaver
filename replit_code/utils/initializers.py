from pathlib import Path
from data.processing.data_cleaner import load_documents, filter_documents
from models.chat_model import initialize_model, initialize_docEmbeddings
from langchain_community.vectorstores import Chroma
from langchain_community.vectorstores.utils import filter_complex_metadata
from langchain.retrievers.self_query.base import SelfQueryRetriever


def get_base_path():
  return Path(__file__).resolve().parents[2]


def load_and_clean_documents():
  file_path = '/home/runner/CloudWeaver/data/cw_db_metadata.pkl'
  documents = load_documents(file_path)
  filtered_documents = filter_documents(documents)
  return filter_complex_metadata(filtered_documents)


def initialize_vector_store():
  doc_embeddings = initialize_docEmbeddings()
  return Chroma(persist_directory="/home/runner/CloudWeaver/data/chroma_db",
                embedding_function=doc_embeddings)


def initialize_retriever(model, vectorstore, document_content_description,
                         metadata_field_info):
  return SelfQueryRetriever.from_llm(
      model,
      vectorstore,
      document_content_description,
      metadata_field_info,
      enable_limit=True,
  )
