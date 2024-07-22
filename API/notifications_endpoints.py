from flask import request, jsonify
from api_config import app, db, messaging
import os
from dotenv import load_dotenv
from flask_jwt_extended import get_jwt_identity, jwt_required, create_access_token
import helpers as h
from datetime import timedelta

load_dotenv()

users = db.collection("user")


# def notify_remaining_calories():
#     docs = users.stream()
#
#     # Iterate through documents and print "fcmtoken"
#     for doc in docs:
#         user_dict = doc.to_dict()
#
#         # Get remaining calories
#         target_calories = int(user_dict['calories'])
#         target_steps = int(user_dict['steps'])
#         calorie_diff =
#
#         # Get remaining steps
#
#         if 'fcmtoken' in user_dict:
#             print(user_dict['fcmtoken'])
#             # build message
#             message = messaging.Message(
#                 data={
#                     'Title' : f' {} calories to go!',
#                     'Body' : f'You still have {} left to go!'
#                 }
#             )