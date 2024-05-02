# george trammell
from flask import Flask, render_template, request, jsonify
from pymongo import MongoClient
import certifi
from flask_cors import CORS
from pymongo.server_api import ServerApi

app = Flask('app')
CORS(app) # enable all routes

uri = "mongodb+srv://gtram:8wN4ms6689uiPoFv@cloudweaver-cluster.yg6mmvh.mongodb.net/?retryWrites=true&w=majority&appName=cloudweaver-cluster"
client = MongoClient(uri, tlsCAFile=certifi.where(), server_api=ServerApi('1'))

@app.route('/')
def hello_world():
    print(request.headers)
    return render_template(
        'index.html',
        user_id=request.headers['X-Replit-User-Id'],
        user_name=request.headers['X-Replit-User-Name'],
        user_roles=request.headers['X-Replit-User-Roles']
    )

# upload route
@app.route('/upload', methods=['POST'])
def upload_object():
    try:
        db = client["cloudweaver"]
        collection = db["prev-chat"]

        data = request.get_json()
        sample_object = {
            "replit_ID": data['replit_ID'],
            "username": data['username'],
            "usertype": data['usertype']
        }

        result = collection.insert_one(sample_object)
        return jsonify({"inserted_id": str(result.inserted_id)}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)