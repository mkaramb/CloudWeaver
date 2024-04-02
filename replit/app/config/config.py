#app/config/config.py
import os

class Config(object):
  if 'GOOGLE_API_KEY' not in os.environ:
    raise EnvironmentError(
        "GOOGLE_API_KEY is not set in environment variables.")

  GOOGLE_API_KEY = os.environ['GOOGLE_API_KEY']