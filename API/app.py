from flask import Flask, request, jsonify
import requests
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import helpers as h
from flask_jwt_extended import create_access_token
from flask_jwt_extended import get_jwt_identity
from flask_jwt_extended import jwt_required
from flask_jwt_extended import JWTManager


cred = credentials.Certificate("mobiledev-f3a76-firebase-adminsdk-jzpgs-1bcbed5027.json")
firebase_admin.initialize_app(cred)

db = firestore.client()


app = Flask(__name__)

@app.route('/')
def home():
    return "Hello, Flask!"

API_KEY = 'PWfpEveaJ9ay6QOLxfGDEg==bl6KRrRSkIQGCDEi'
CALORIE_URL = 'https://api.calorieninjas.com/v1/nutrition'
RECIPE_URL = 'https://api.calorieninjas.com/v1/recipe'

@app.route('/nutrition', methods=['POST'])
def get_nutrition_info():
    data = request.json
    food_item = data.get('food_item')

    if not food_item:
        return jsonify({'error': 'No food item provided'}), 400

    headers = {
        'X-Api-Key': API_KEY
    }
    params = {
        'query': food_item
    }

    response = requests.get(CALORIE_URL, headers=headers, params=params)

    if response.status_code == 200:
        return jsonify(response.json()), 200
    else:
        return jsonify({'error': 'Failed to retrieve nutrition information'}), response.status_code

@app.route('/create_recipe', methods=['POST'])
def create_recipe():
    data = request.json
    recipe_name = data.get('recipe_name')
    ingredients = data.get('ingredients')
    instructions = data.get('instructions')

    if not recipe_name or not ingredients or not instructions:
        return jsonify({'error': 'Missing recipe information'}), 400

    recipe_ref = db.collection('recipes').document()
    recipe_ref.set({
        'recipe_name': recipe_name,
        'ingredients': ingredients,
        'instructions': instructions
    })

    return jsonify({'id': recipe_ref.id}), 201

@app.route('/get_recipe', methods=['GET'])
def get_recipe():
    recipe_id = request.args.get('id')

    if not recipe_id:
        return jsonify({'error': 'No recipe ID provided'}), 400

    recipe_ref = db.collection('recipes').document(recipe_id)
    recipe = recipe_ref.get()

    if recipe.exists:
        return jsonify(recipe.to_dict()), 200
    else:
        return jsonify({'error': 'Recipe not found'}), 404

@app.route('/add_meal', methods=['POST'])
def create_meal():
    data = request.json
    user_id = data.get('user_id')
    meal_name = data.get('meal_name')
    ingredients = data.get('ingredients')
    image_url = data.get('image_url')
    time_hours = data.get('time_hours')
    time_minutes = data.get('time_minutes')


    current_date = datetime.utcnow().strftime('%Y-%m-%d')

    if not user_id or not meal_name or not ingredients:
        return jsonify({'error': 'Missing meal information'}), 400

    # Check if ingredients is a list of dictionaries
    if not isinstance(ingredients, list) or not all(isinstance(i, dict) for i in ingredients):
        return jsonify({'error': 'Ingredients must be a list of dictionaries'}), 400

    meal_ref = db.collection('meals').document()
    meal_data = {
        'user_id': user_id,
        'meal_name': meal_name,
        'ingredients': ingredients,
        'image_url': image_url,
        'time_hours': time_hours,
        'time_minutes': time_minutes,
        'date': current_date
    }

    meal_ref.set(meal_data)

    return jsonify({'id': meal_ref.id}), 201

@app.route('/get_meal', methods=['POST'])
def get_meal():
    data = request.json
    user_doc_id = data.get('user_doc_id')
    meal_name = data.get('meal_name')

    if not meal_name or not user_doc_id:
        return jsonify({'error': 'User ID and meal name are required'}), 400

    # user_ref = db.collection('user').document(user_doc_id)
    meals_ref = db.collection('meals').where('user_id', '==', user_doc_id).where('meal_name', '==', meal_name)
    meals = meals_ref.stream()

    result = None

    for meal in meals:
        meal_data = meal.to_dict()
        ingredients = meal_data.get('ingredients', [])
        detailed_ingredients = []
        total_calories = 0

        for ingredient in ingredients:
            item = ingredient.get('item')
            quantity = ingredient.get('quantity')

            if item:
                headers = {
                    'X-Api-Key': API_KEY
                }
                params = {
                    'query': item
                }

                response = requests.get(CALORIE_URL, headers=headers, params=params)
                if response.status_code == 200:
                    nutrition_info = response.json()
                    if nutrition_info['items']:
                        calorie_info = nutrition_info['items'][0].get('calories', 0)
                        detailed_ingredients.append({'item': item, 'calories': calorie_info})
                        total_calories += calorie_info

        result = {
            'meal_name': meal_name,
            'image_url': meal_data.get('image_url'),
            'ingredients': detailed_ingredients,
            'total_calories': total_calories
        }
        break  

    if not result:
        return jsonify({'error': 'Meal not found'}), 404

    return jsonify(result), 200


def get_steps_for_date(user_doc_id, date):
    user_ref = db.collection('user').document(user_doc_id).collection('dailySteps').document(date)
    doc = user_ref.get()

    if doc.exists:
        return doc.to_dict()['steps']
    else:
        return None

@app.route('/get_steps', methods=['GET'])
def get_steps():
    user_doc_id = request.args.get('user_doc_id')
    date = request.args.get('date')  # Expected date format: YYYY-MM-DD

    if not user_doc_id or not date:
        return jsonify({'error': 'Missing userid or date'}), 400

    steps = get_steps_for_date(user_doc_id, date)

    if steps is not None:
        return jsonify({'steps': steps}), 200
    else:
        return jsonify({'error': 'No steps data found for the specified date'}), 404


def get_calories_for_date(user_doc_id, date):
    user_ref = db.collection('user').document(user_doc_id).collection('dailySteps').document(date)
    doc = user_ref.get()

    if doc.exists:
        return doc.to_dict()['calories']
    else:
        return None

@app.route('/get_calories', methods=['GET'])
def get_calories():
    user_doc_id = request.args.get('user_doc_id')
    date = request.args.get('date')  # Expected date format: YYYY-MM-DD

    if not user_doc_id or not date:
        return jsonify({'error': 'Missing userid or date'}), 400

    calories = get_calories_for_date(user_doc_id, date)

    if calories is not None:
        return jsonify({'calories': calories}), 200
    else:
        return jsonify({'error': 'No steps data found for the specified date'}), 404




# @app.route('/recipe_search', methods=['POST'])
# def recipe_search():
#     data = request.json
#     recipe_name = data.get('recipe_name')
#
#     if not recipe_name:
#         return jsonify({'error': 'No recipe name provided'}), 400
#
#     headers = {
#         'X-Api-Key': API_KEY
#     }
#     recipe_params = {
#         'query': recipe_name
#     }
#
#     recipe_response = requests.get(RECIPE_URL, headers=headers, params=recipe_params)
#
#     if recipe_response.status_code == 200:
#         return jsonify(recipe_response.json()), 200
#     else:
#         print(recipe_response.content)  # Debugging: print the response content
#         return jsonify({'error': 'Failed to retrieve recipe information'}), recipe_response.status_code



if __name__ == "__main__":
    app.run(debug=True)

