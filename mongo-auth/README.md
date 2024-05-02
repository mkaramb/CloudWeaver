# User Authentication and Chat Storage with Replit OAuth and MongoDB Atlas
#### This folder references [@george137/replit-auth-test](https://replit.com/@george137/replit-auth-test#templates/index.html)

## To Add OAuth in Replit HTML:
```
<body>
  {% if user_id %}
  <h4>Hello, {{ user_name }}!</h4>
  <p>Your user id is {{ user_id }}.</p>
  {% else %} Hello! Please log in.
  <div>
    <script
      authed="location.reload()"
      src="https://auth.util.repl.co/script.js"
    ></script>
  </div>
  {% endif %}
</body>
```
## Home Route Example:
```
@app.route('/')
def hello_world():
    return render_template(
        'index.html',
        user_id=request.headers['X-Replit-User-Id'],
        user_name=request.headers['X-Replit-User-Name'],
        user_roles=request.headers['X-Replit-User-Roles']
    )
```
## MongoDB Setup:
MongoDB Atlas: https://cloud.mongodb.com/v2/

Conncetion string = "mongodb+srv://gtram:8wN4ms6689uiPoFv@cloudweaver-cluster.yg6mmvh.mongodb.net/"

USING URL ENCODING, E.X.: /?replitID=adsj23rn3d
```
!python -m pip install "pymongo[srv]"

from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

uri = "mongodb+srv://gtram:8wN4ms6689uiPoFv@cloudweaver-cluster.yg6mmvh.mongodb.net/?retryWrites=true&w=majority&appName=cloudweaver-cluster"
```
## Create a new client and connect to the server
```
client = MongoClient(uri, server_api=ServerApi('1'))
```
## Schemas:
```
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
```

## Send a ping to confirm a successful connection
```
try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)
```
