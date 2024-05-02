# george trammell
import certifi
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

uri = "mongodb+srv://gtram:8wN4ms6689uiPoFv@cloudweaver-cluster.yg6mmvh.mongodb.net/?retryWrites=true&w=majority&appName=cloudweaver-cluster"

# slightly different certifi setup for local
client = MongoClient(uri, tlsCAFile=certifi.where(), server_api=ServerApi('1'))

try:
    db = client["cloudweaver"]
    collection = db["prev-chat"]

    sample_object = {
        "replit_ID": "{replit_ID}",
        "username": "{username}",
        "usertype": "{usertype}"
    }

    # insert
    result = collection.insert_one(sample_object)
    print("Inserted object ID:", result.inserted_id)

except Exception as e:
    print(e)