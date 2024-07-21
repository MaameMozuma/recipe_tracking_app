from flask import request, jsonify
from api_config import app, db
import os
from dotenv import load_dotenv
from flask_jwt_extended import get_jwt_identity, jwt_required, create_access_token
import helpers as h
from datetime import timedelta

load_dotenv()

users = db.collection("user")

@app.route('/login', methods=['POST'])
def login():
    """Logs the user in, requires a username and password"""
    global users

    if h.valid_login_fields(request) and h.verified_credentials(users, request):
        username = request.json.get("username", None)
        print(username)
        expires = timedelta(days=30)
        access_token = create_access_token(username, expires_delta=expires)

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
@jwt_required()
def view_account():
    current_user = get_jwt_identity()

    # Get user document
    user_ref = users.document(current_user)
    user_doc = user_ref.get()

    if user_doc.exists:
        user_data = user_doc.to_dict()
        response = {
            "username": user_data.get("username", ""),
            "email": user_data.get("email", ""),
            "height": user_data.get("height", ""),
            "weight": user_data.get("weight", ""),
            "dob": user_data.get("dob", ""),
            "telno": user_data.get("phone_number", "")
        }
        return jsonify(response), 200

    else:
        return jsonify({"error": "User not found"}), 404

@app.route('/update_account', methods=['PATCH'])
@jwt_required()
def update_account():
    current_user = get_jwt_identity()
    data = request.get_json()

    #Validate update fields
    if not h.validate_update_fields(request):
        return jsonify({"error":"One or more of the update fields is invalid"}), 400

    # Get user document
    user_ref = users.document(current_user)
    user_doc = user_ref.get()

    if user_doc.exists:
        # Update the user document
        user_ref.update({
            "phone_number": data.get("phone_number"),
            "height": data.get("height"),
            "weight": data.get("weight")
        })
        return jsonify({"message": "Profile updated successfully"}), 200
    else:
        return jsonify({"error": "User not found"}), 404




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
