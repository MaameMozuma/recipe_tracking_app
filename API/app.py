from flask import Flask, request, jsonify
import requests
import firebase_admin
from firebase_admin import credentials, firestore
import json
import helpers as h

from flask_jwt_extended import create_access_token
from flask_jwt_extended import get_jwt_identity
from flask_jwt_extended import jwt_required
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

## Impotrt other endpoints
import usergoals_endpoints
import nutrition_steps_endpoints

@app.route('/login', methods=['POST'])
def login():
    """Logs the user in, requires a username and password"""
    global users

    if h.valid_login_fields(request) and h.verified_credentials(users, request):
        username = request.json.get("username", None)
        print(username)
        access_token = create_access_token(username)

        return jsonify(access_token = access_token), 200

    else:
        return jsonify({"msg": "Bad username or password"}), 400


@app.route('/signup', methods=['POST'])
def signup():

    data = request.get_json()
    global users

    try:
        # check account does not exist
        if h.user_exists(users, data.get('username'), data.get('email')):
            return jsonify({"msg" : "User already exists"}), 400

        # check fields
        if not h.valid_signup_fields(request):
            return jsonify({"msg" : "One ore more fields are not as expected. Check that "
                                    "no required fields are missing and that password and "
                                    "email are valid"}), 400

        # clean fields
        cleaned_data = h.clean_signup_fields(request)

        # Salt and hash passwprd
        salt, hashed_password = h.hash_password(cleaned_data.get('password'))
        cleaned_data['salt'] = salt
        cleaned_data['password'] = hashed_password

        # save document/account
        username = cleaned_data.get('username')
        users.document(username).set(cleaned_data)
    except Exception as e:
        print(e)
        return jsonify("An error occured during account creation"), 500

    return jsonify({"msg" : f"Account for username: {username} created"}) ,201


@app.route('/view_account', methods=['GET'])
def view_profile():

    return

@app.route('/update_profile', methods=['PATCH'])
def update_profile():
    return

@app.route('/send_otp', methods=['GET'])
def send_otp():
    """Sends an OTP to the client based on the provided phone number"""

    data = request.get_json()
    number = data.get('phone_number')

    if not number:
        return jsonify({"error": "Phone number is required"}), 400

    response, status_code = h.generate_otp(number)

    return jsonify(response), status_code



@app.route('/verify_otp', methods=['POST'])
def verify_otp():
    """Verifies the OTP sent by a client"""

    data = request.get_json()
    number = data.get('phone_number')
    code = data.get('code')

    if not number or not code:
        return jsonify({"error": "Phone number or Code are missing"}), 400

    response, status_code = h.verify_otp(number, code)

    return jsonify(response), status_code




if __name__ == "__main__":
    app.run(debug=True)

