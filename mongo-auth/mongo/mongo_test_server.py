# george trammell
from flask import Flask, jsonify
import certifi
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

# TO USE: curl -X POST http://127.0.0.1:5000/upload

app = Flask(__name__)
uri = "mongodb+srv://gtram:8wN4ms6689uiPoFv@cloudweaver-cluster.yg6mmvh.mongodb.net/?retryWrites=true&w=majority&appName=cloudweaver-cluster"

# certifi to make this work
client = MongoClient(uri, tlsCAFile=certifi.where(), server_api=ServerApi('1'))

@app.route('/upload', methods=['POST'])
def upload_object():
    try:
        db = client["cloudweaver"]
        # prev-chat contains 
        collection = db["prev-chat"]

        sample_object = {
            "replit_ID": "{replit_ID}",
            "username": "{username}",
            "usertype": "{usertype}"
        }

        result = collection.insert_one(sample_object)
        return jsonify({"inserted_id": str(result.inserted_id)}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run()

"""
SCHEMA:

cloudweaver.replit-users:
{"_id":{"$oid":"6625954047a32746d0efaaf8"},
"replit_ID":"X-Replit-User-Id",
"username":"X-Replit-User-Name",
"usertype":"X-Replit-User-Roles"
}

cloudweaver.prev-chat:
{"_id":{"$oid":"6625954047a32746d0efaaf8"},
"replit_ID":"X-Replit-User-Id",
"initial_prompt":"initial_prompt",
"terraform_code":"terraform_code"
}
"""