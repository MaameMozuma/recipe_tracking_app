from flask import Flask
import firebase_admin
from firebase_admin import credentials, firestore
from flask_jwt_extended import JWTManager

## Initialize Credentials & DB
cred = credentials.Certificate("mobiledev-f3a76-firebase-adminsdk-jzpgs-1bcbed5027.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

## Initialize flask app & JWT
app = Flask(__name__)
app.config["JWT_SECRET_KEY"] = "0a65sd1a6wlkncd[a0 s9y][q-09ej"
jwt = JWTManager(app)
users = db.collection("user")
