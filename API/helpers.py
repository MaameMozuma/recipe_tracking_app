import json
import firebase_admin
from firebase_admin import credentials, firestore
import os
import hashlib
import requests
from dotenv import load_dotenv
from flask import jsonify
import re

# Setup collections
load_dotenv()
cred = credentials.Certificate(os.getenv("firebase_cred"))





def valid_login_fields(request):
    """Verifies that a login request contains
    only the required fields"""

    data = request.get_json()
    necessary_fields = ['username','password']

    for element in data:
        if element not in necessary_fields:
            return False

    return True

def validate_password(password):
    """uses a regular expression to validate the password
    should be at least 8 characters, 1 number, 1 special character"""

    if re.fullmatch(r'^(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$', password):
        return True

    return False

def validate_email(email):
    """uses a regular expression to validate the email"""
    if re.fullmatch(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', email):
        return True

    return False

def valid_signup_fields(request):
    """Checks that a sign up request contains only the required fields"""

    data = request.get_json()
    necessary_fields = ['username', 'password', 'email', 'height', 'dob', 'weight',
                        'phone_number']

    # check num of fields is correct
    if len(data) != len(necessary_fields):
        return False

    for element in necessary_fields:
        if element not in data: # Check for necessary fields
            return False
        if not data[element]: # check for empty fields
            return False

    # Validate password and email
    if not (validate_email(data.get('email')) and validate_password(data.get('password'))):
        return False

    return True


def user_exists(users_ref, username = None, email = None):
    """ Checks to see whether a user email or username"""

    username_doc = username_exists(users_ref, username)
    email_doc = email_exists(users_ref, email)

    return email_doc or username_doc

def username_exists(users_ref, username):
    """ Checks to see whether a user email or username"""

    username_doc = users_ref.document(username).get()

    return username_doc.exists

def email_exists(users_ref, email):
    """Checks to see whether a user with the given email exists"""

    query = users_ref.where('email', '==', email).limit(1).stream()
    for doc in query:
        return True
    return False



def verified_credentials(users_ref, request):
    """Checks whether the request contains a valid username and password
    combination"""

    data = request.get_json()
    username = data.get('username')
    password = data.get('password')


    if user_exists(users_ref, username):
        user_doc = users_ref.document(username).get()
        salt = user_doc.get('salt')   # Get password salt
        hashed_password = hashlib.pbkdf2_hmac('sha256', password.encode('utf-8'), salt, 100000)

        # Verify username and pasword combo
        if user_doc.get('password') == hashed_password and user_doc.get('username') == username:
            return True

    return False


def hash_password(password):
    # Generate a salt
    salt = os.urandom(16)

    # Create a salted hash
    hashed_password = hashlib.pbkdf2_hmac('sha256', password.encode('utf-8'), salt, 100000)

    return salt, hashed_password

def clean_signup_fields(request):
    """ Cleans the fields from a signup request and returns
    the cleaned data"""

    data = request.get_json()

    # clean fields
    cleaned_data = {'username' : data.get('username').strip(),
                    'email' : data.get('email').strip(),
                    'password' :  data.get('password').strip(),
                    'height' : data.get('height').strip(),
                    'dob' : data.get('dob'),
                    'weight' : data.get('weight'),
                    }

    return cleaned_data

def generate_otp(number):
    client = requests.Session()
    print("arkesel key is," + os.getenv("arkesel"))
    headers = {
        "api-key" : os.getenv("arkesel")

    }

    url = "https://sms.arkesel.com/api/otp/generate"

    request_body = {
        "expiry": "5",
        "length": "6",
        "medium": "sms",
        "message": "Hey! This is your OTP from Ibukun & Co, %otp_code%",
        "number": number,
        "sender_id": "Ibukun & Co",
        "type": "numeric"
    }

    try:
        response = client.post(url, headers=headers, json=request_body)
        response.raise_for_status()
        print(response.text)
        return {"msg": "OTP sent"}, 200
    except requests.exceptions.RequestException as e:
        print("An error occurred:", e)
        return {"error": "OTP failed to send"}, 500

def verify_otp(number, code):
    client = requests.Session()

    headers = {
        "api-key":  os.getenv("arkesel")
    }

    url = "https://sms.arkesel.com/api/otp/verify"

    request_body = {
        "code": code,
        "number": number
    }

    try:
        response = client.post(url, headers=headers, json=request_body)
        response.raise_for_status()
        json_response = json.loads(response.text)
        print(json_response)

        if json_response['code'] != "1100":
            return {"msg": "Invalid OTP"}, 401
        else:
            return {"msg": "OTP verified"}, 200
    except requests.exceptions.RequestException as e:
        print("An error occurred:", e)
        return {"error": "Invalid OTP"}, 401


def verify_and_return_goals(request):
    """Verifies that a users goals are all numeric"""

    data = request.get_json()

    #Try int conversion
    try:
        for element in data:
            data[element] = int(data[element])

    except Exception as e:
        print(e)
        return False, data

    return True, data


def validate_update_fields(request):
    """Validates sign up fields to ensure that the data entered
    is valid"""

    data = request.get_json()
    height = float(data['height'])
    weight = float(data['weight'])
    number = data['phone_number']

    # check height
    if height >= 215 or height <= 60:
        return False

    # check weight
    if weight >= 200 or weight <=30:
        return False

    # check number
    if len(number) >= 13 or len(number) <10:
        return False

    return True





    # check phone number



