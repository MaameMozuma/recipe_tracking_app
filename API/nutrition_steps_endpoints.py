from flask import request, jsonify
from api_config import app, db, bucket
import os
from dotenv import load_dotenv
from flask_jwt_extended import get_jwt_identity, jwt_required
import helpers as h
import requests
from datetime import datetime, date, timedelta
import random

load_dotenv()

users = db.collection("user")
steps_collection = db.collection('steps')
calories_collection = db.collection('calories')



@app.route('/', methods=['POST'])
def home():
    return "Hello, Flask!"

API_KEY = os.getenv('API_KEY')
CALORIE_URL = os.getenv('CALORIE_URL')
RECIPE_URL = os.getenv('RECIPE_URL')

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

#MEALS
@app.route('/add_meal', methods=['POST'])
@jwt_required()
def create_meal():
    current_user = get_jwt_identity()
    data = request.json
    meal_name = data.get('meal_name')
    ingredients = data.get('ingredients')
    image_url = data.get('image_url')
    time_hours = data.get('time_hours')
    time_minutes = data.get('time_minutes')


    current_date = datetime.utcnow().strftime('%Y-%m-%d')

    if not current_user or not meal_name or not ingredients:
        return jsonify({'error': 'Missing meal information'}), 400

    # Check if ingredients is a list of dictionaries
    if not isinstance(ingredients, list) or not all(isinstance(i, dict) for i in ingredients):
        return jsonify({'error': 'Ingredients must be a list of dictionaries'}), 400

    meal_ref = db.collection('meals').document()
    meal_data = {
        'user_id': current_user,
        'meal_name': meal_name,
        'ingredients': ingredients,
        'image_url': image_url,
        'time_hours': time_hours,
        'time_minutes': time_minutes,
        'date': current_date,
        'total_calories': 0
    }

    meal_ref.set(meal_data)

    return jsonify({'id': meal_ref.id}), 201


@app.route('/get_meal', methods=['GET'])
@jwt_required()
def get_meal():
    current_user = get_jwt_identity()
    meal_name = request.args.get('meal_name')

    if not current_user or not meal_name:
        return jsonify({'error': 'User ID and meal name are required'}), 400

    meals_ref = db.collection('meals').where('user_id', '==', current_user).where('meal_name', '==', meal_name)
    meals = meals_ref.stream()

    result = None
    meals_list = [meal.to_dict() for meal in meals]

    if not meals_list:
        return jsonify({'error': 'Meal not found'}), 404

    for meal_data in meals_list:
        ingredients = meal_data.get('ingredients', [])
        detailed_ingredients = []
        total_calories = 0

        ingredient_names = [ingredient.get('item') for ingredient in ingredients if ingredient.get('item')]

        if ingredient_names:
            headers = {
                'X-Api-Key': API_KEY
            }
            params = {
                'query': ', '.join(ingredient_names)
            }

            response = requests.get(CALORIE_URL, headers=headers, params=params)
            if response.status_code == 200:
                nutrition_info = response.json()
                items = nutrition_info.get('items', [])

                for ingredient in ingredients:
                    item_name = ingredient.get('item').lower()
                    matching_item = next((item for item in items if item['name'].lower() == item_name), None)
                    if matching_item:
                        item_calories = matching_item.get('calories', 0)
                    else:
                        item_calories = 0
                    detailed_ingredients.append({'item': ingredient.get('item'), 'calories': item_calories})
                    total_calories += item_calories

        result = {
            'meal_name': meal_name,
            'image_url': meal_data.get('image_url'),
            'ingredients': detailed_ingredients,
            'total_calories': total_calories,
            'time_hours': meal_data.get('time_hours'),
            'time_minutes': meal_data.get('time_minutes'),
            'date': meal_data.get('date')
        }
        break

    return jsonify(result), 200


@app.route('/get_all_meals', methods=['GET'])
def get_all_meals():
    meals_ref = db.collection('meals')
    meals = meals_ref.stream()

    result = []
    for meal in meals:
        meal_data = meal.to_dict()
        ingredients = meal_data.get('ingredients', [])
        detailed_ingredients = []
        total_calories = 0.0

        ingredient_names = [ingredient.get('item') for ingredient in ingredients if ingredient.get('item')]

        if ingredient_names:
            headers = {
                'X-Api-Key': API_KEY
            }
            params = {
                'query': ', '.join(ingredient_names)
            }

            response = requests.get(CALORIE_URL, headers=headers, params=params)
            if response.status_code == 200:
                nutrition_info = response.json()
                items = nutrition_info.get('items', [])

                for ingredient in ingredients:
                    item_name = ingredient.get('item').lower()
                    matching_item = next((item for item in items if item['name'].lower() == item_name), None)
                    if matching_item:
                        item_calories = matching_item.get('calories', 0)
                    else:
                        item_calories = 0
                    detailed_ingredients.append({'item': ingredient.get('item'), 'calories': item_calories})
                    total_calories += item_calories

        result.append({
            'meal_id': meal.id,
            'meal_name': meal_data.get('meal_name'),
            'image_url': meal_data.get('image_url'),
            'ingredients': detailed_ingredients,
            'total_calories': total_calories,
            'time_hours': meal_data.get('time_hours'),
            'time_minutes': meal_data.get('time_minutes'),
            'date': meal_data.get('date')  
        })

    return jsonify(result), 200

@app.route('/get_all_user_meals', methods=['GET'])
@jwt_required()
def get_all_user_meals():
    current_user = get_jwt_identity()
    meals_ref = db.collection('meals').where('user_id', '==', current_user)
    meals = meals_ref.stream()

    result = []
    for meal in meals:
        meal_data = meal.to_dict()
        ingredients = meal_data.get('ingredients', [])
        detailed_ingredients = []
        total_calories = 0

        ingredient_names = [ingredient.get('item') for ingredient in ingredients if ingredient.get('item')]

        if ingredient_names:
            headers = {
                'X-Api-Key': API_KEY
            }
            params = {
                'query': ', '.join(ingredient_names)
            }

            response = requests.get(CALORIE_URL, headers=headers, params=params)
            if response.status_code == 200:
                nutrition_info = response.json()
                items = nutrition_info.get('items', [])

                for ingredient in ingredients:
                    item_name = ingredient.get('item').lower()
                    matching_item = next((item for item in items if item['name'].lower() == item_name), None)
                    if matching_item:
                        item_calories = matching_item.get('calories', 0)
                    else:
                        item_calories = 0
                    detailed_ingredients.append({'item': ingredient.get('item'), 'calories': item_calories})
                    total_calories += item_calories

        result.append({
            'meal_id': meal.id,
            'meal_name': meal_data.get('meal_name'),
            'image_url': meal_data.get('image_url'),
            'ingredients': detailed_ingredients,
            'total_calories': total_calories,
            'time_hours': meal_data.get('time_hours'),
            'time_minutes': meal_data.get('time_minutes'),
            'date': meal_data.get('date')  
        })

    return jsonify(result), 200

@app.route('/delete_meal', methods=['DELETE'])
@jwt_required()
def delete_meal():
    current_user = get_jwt_identity()
    meal_name = request.args.get('meal_name')

    if not current_user or not meal_name:
        return jsonify({'error': 'User ID and meal name are required'}), 400

    meals_ref = db.collection('meals').where('user_id', '==', current_user).where('meal_name', '==', meal_name)
    meals = meals_ref.stream()

    for meal in meals:
        meal_ref = db.collection('meals').document(meal.id)
        meal_ref.delete()
        return jsonify({'msg': 'Meal deleted'}), 200

    return jsonify({'error': 'Meal not found'}), 404

@app.route('/update_meal', methods=['PUT'])
@jwt_required()
def update_meal():
    current_user = get_jwt_identity()
    data = request.json
    meal_name = data.get('meal_name')
    ingredients = data.get('ingredients')
    image_url = data.get('image_url')
    time_hours = data.get('time_hours')
    time_minutes = data.get('time_minutes')

    if not current_user or not meal_name or not ingredients:
        return jsonify({'error': 'Missing meal information'}), 400

    if not isinstance(ingredients, list) or not all(isinstance(i, dict) for i in ingredients):
        return jsonify({'error': 'Ingredients must be a list of dictionaries'}), 400

    meals_ref = db.collection('meals').where('user_id', '==', current_user).where('meal_name', '==', meal_name)
    meals = meals_ref.stream()

    for meal in meals:
        meal_ref = db.collection('meals').document(meal.id)
        meal_ref.update({
            'ingredients': ingredients,
            'image_url': image_url,
            'time_hours': time_hours,
            'time_minutes': time_minutes
        })
        return jsonify({'msg': 'Meal updated'}), 200

    return jsonify({'error': 'Meal not found'}), 404


# RECIPES
@app.route('/add_recipe', methods=['POST'])
@jwt_required()
def add_recipe():
    current_user = get_jwt_identity()
    data = request.json
    recipe_name = data.get('recipe_name')
    ingredients = data.get('ingredients')
    steps = data.get('steps')

    current_date = datetime.utcnow().strftime('%Y-%m-%d')

    if not current_user or not recipe_name or not ingredients or not steps:
        return jsonify({'error': 'Missing meal information'}), 400


    if not isinstance(ingredients, list) or not all(isinstance(i, dict) for i in ingredients):
        return jsonify({'error': 'Ingredients must be a list of dictionaries'}), 400

    if not isinstance(steps, list) or not all(isinstance(i, dict) for i in steps):
        return jsonify({'error': 'Steps must be a list of dictionaries'}), 400

    recipe_ref = db.collection('recipes').document()
    recipe_data = {
        'user_id': current_user,
        'recipe_name': recipe_name,
        'ingredients': ingredients,
        'steps': steps,
        'date': current_date
    }

    recipe_ref.set(recipe_data)

    return jsonify({'id': recipe_ref.id}), 201

@app.route('/get_recipe', methods=['GET'])
@jwt_required()
def get_recipe():
    current_user = get_jwt_identity()
    recipe_name = request.args.get('recipe_name')

    if not current_user or not recipe_name:
        return jsonify({'error': 'User ID and recipe name are required'}), 400

    recipe_ref = db.collection('recipes').where('user_id', '==', current_user).where('recipe_name', '==', recipe_name)
    recipes = recipe_ref.stream()

    result = None
    recipes_list = [recipe.to_dict() for recipe in recipes]

    if not recipes_list:
        return jsonify({'error': 'Recipe not found'}), 404

    for recipe_data in recipes_list:
        ingredients = recipe_data.get('ingredients', [])
        detailed_ingredients = []
        steps = recipe_data.get('steps', [])
        total_calories = 0

        ingredient_names = [ingredient.get('item') for ingredient in ingredients if ingredient.get('item')]

        if ingredient_names:
            headers = {
                'X-Api-Key': API_KEY
            }
            params = {
                'query': ', '.join(ingredient_names)
            }

            response = requests.get(CALORIE_URL, headers=headers, params=params)
            if response.status_code == 200:
                nutrition_info = response.json()
                items = nutrition_info.get('items', [])

                for ingredient in ingredients:
                    item_name = ingredient.get('item').lower()
                    matching_item = next((item for item in items if item['name'].lower() == item_name), None)
                    if matching_item:
                        item_calories = matching_item.get('calories', 0)
                    else:
                        item_calories = 0
                    detailed_ingredients.append({'item': ingredient.get('item'), 'calories': item_calories})
                    total_calories += item_calories

        result = {
            'recipe_name': recipe_name,
            'ingredients': detailed_ingredients,
            'steps': steps,
            'total_calories': total_calories
        }
        break

    return jsonify(result), 200


@app.route('/recipes/<recipe_id>', methods=['GET'])
@jwt_required()
def get_recipe_by_id(recipe_id):
    current_user = get_jwt_identity()
    if not recipe_id:
        return jsonify({'error': 'Recipe ID is required'}), 400

    # Query Firestore for the recipe by ID
    doc_ref = db.collection('recipes').document(recipe_id)
    doc = doc_ref.get()

    if not doc.exists:
        return jsonify({'error': 'Recipe not found'}), 404

    recipe_data = doc.to_dict()
    
    # if recipe_data.get('user_id') != current_user:
    #     return jsonify({'error': 'Unauthorized access'}), 403

    ingredients = recipe_data.get('ingredients', [])
    detailed_ingredients = []
    duration = recipe_data.get('duration', None)
    details = recipe_data.get('details', None)
    steps = recipe_data.get('steps', [])
    user_id = recipe_data.get('user_id', None)
    image_url = recipe_data.get('image_url', None)
    total_calories = 0

    ingredient_names = [ingredient.get('item') for ingredient in ingredients if ingredient.get('item')]

    if ingredient_names:
        headers = {
            'X-Api-Key': API_KEY
        }
        params = {
            'query': ', '.join(ingredient_names)
        }

        response = requests.get(CALORIE_URL, headers=headers, params=params)
        if response.status_code == 200:
            nutrition_info = response.json()
            items = nutrition_info.get('items', [])

            for ingredient in ingredients:
                item_name = ingredient.get('item').lower()
                matching_item = next((item for item in items if item['name'].lower() == item_name), None)
                if matching_item:
                    item_calories = matching_item.get('calories', 0)
                else:
                    item_calories = 0
                detailed_ingredients.append({'item': ingredient.get('item'), 'quantity': ingredient.get('quantity'), 'calories': item_calories})
                total_calories += item_calories

    result = {
        'recipe_id': recipe_id,
        'recipe_name': recipe_data.get('recipe_name', ''),
        'ingredients': detailed_ingredients,
        'details': details,
        'duration': duration,
        'steps': steps,
        'total_calories': total_calories,
        'image_url': image_url,
        'user_recipe': True if user_id == current_user else False,
    }

    return jsonify(result), 200


@app.route('/get_all_recipes', methods=['GET'])
@jwt_required()
def get_all_recipes():
    current_user = get_jwt_identity()
    recipes_ref = db.collection('recipes')
    recipes = recipes_ref.stream()

    result = []
    for recipe in recipes:
        recipe_data = recipe.to_dict()
        ingredients = recipe_data.get('ingredients', [])
        details = recipe_data.get('details', None)
        duration = recipe_data.get('duration', None)
        detailed_ingredients = []
        steps = recipe_data.get('steps', [])
        user_id = recipe_data.get('user_id', None)
        image_url = recipe_data.get("image_url", None)
        total_calories = 0

        ingredient_names = [ingredient.get('item') for ingredient in ingredients if ingredient.get('item')]

        if ingredient_names:
            headers = {
                'X-Api-Key': API_KEY
            }
            params = {
                'query': ', '.join(ingredient_names)
            }

            response = requests.get(CALORIE_URL, headers=headers, params=params)
            if response.status_code == 200:
                nutrition_info = response.json()
                items = nutrition_info.get('items', [])

                for ingredient in ingredients:
                    item_name = ingredient.get('item').lower()
                    matching_item = next((item for item in items if item['name'].lower() == item_name), None)
                    if matching_item:
                        item_calories = matching_item.get('calories', 0)
                    else:
                        item_calories = 0
                    detailed_ingredients.append({'item': ingredient.get('item'), 'quantity': ingredient.get('quantity'), 'calories': item_calories})
                    total_calories += item_calories

        result.append({
            'recipe_id': recipe.id,
            'recipe_name': recipe_data.get('recipe_name'),
            'details': details,
            'ingredients': detailed_ingredients,
            'steps': steps,
            'total_calories': total_calories,
            'duration': duration,
            "image_url": image_url,
            'user_recipe': True if current_user == user_id  else False 
        })

    return jsonify(result), 200

@app.route('/get_all_user_recipes', methods=['GET'])
@jwt_required()
def get_all_user_recipes():
    current_user = get_jwt_identity()
    print(current_user)
    recipes_ref = db.collection('recipes').where('user_id', '==', current_user)
    recipes = recipes_ref.stream()

    result = []
    for recipe in recipes:
        recipe_data = recipe.to_dict()
        ingredients = recipe_data.get('ingredients', [])
        details = recipe_data.get('details', None)
        duration = recipe_data.get('duration', None)
        detailed_ingredients = []
        steps = recipe_data.get('steps', [])
        image_url = recipe_data.get("image_url", None)
        total_calories = 0

        ingredient_names = [ingredient.get('item') for ingredient in ingredients if ingredient.get('item')]

        if ingredient_names:
            headers = {
                'X-Api-Key': API_KEY
            }
            params = {
                'query': ', '.join(ingredient_names)
            }

            response = requests.get(CALORIE_URL, headers=headers, params=params)
            if response.status_code == 200:
                nutrition_info = response.json()
                items = nutrition_info.get('items', [])

                for ingredient in ingredients:
                    item_name = ingredient.get('item').lower()
                    matching_item = next((item for item in items if item['name'].lower() == item_name), None)
                    if matching_item:
                        item_calories = matching_item.get('calories', 0)
                    else:
                        item_calories = 0
                    detailed_ingredients.append({'item': ingredient.get('item'), 'quantity': ingredient.get('quantity'), 'calories': item_calories})
                    total_calories += item_calories

        result.append({
            'recipe_id': recipe.id,
            'recipe_name': recipe_data.get('recipe_name'),
            'details': details,
            'ingredients': detailed_ingredients,
            'steps': steps,
            'total_calories': total_calories,
            'duration': duration,
            "image_url": image_url,
            'user_recipe': True,
        })

    return jsonify(result), 200

@app.route('/delete_recipe/<recipe_id>', methods=['DELETE'])
@jwt_required()
def delete_recipe(recipe_id):
    current_user = get_jwt_identity()

    if not current_user or not recipe_id:
        return jsonify({'error': 'User ID and recipe ID are required'}), 400

    recipe_ref = db.collection('recipes').document(recipe_id)
    recipe = recipe_ref.get()

    if not recipe.exists:
        return jsonify({'error': 'Recipe not found'}), 404

    if recipe.to_dict().get('user_id') != current_user:
        return jsonify({'error': 'Unauthorized access to the recipe'}), 403

    recipe_ref.delete()
    return jsonify({'msg': 'Recipe deleted'}), 200

@app.route('/update_recipe', methods=['PUT'])
@jwt_required()
def update_recipe():
    current_user = get_jwt_identity()
    data = request.json
    recipe_id = data.get('recipe_id')
    recipe_name = data.get('recipe_name')
    details = data.get('details')
    duration = data.get('duration')
    ingredients = data.get('ingredients')
    steps = data.get('steps')

    if not current_user or not recipe_id or not ingredients or not steps:
        return jsonify({'error': 'Missing meal information'}), 400

    if not isinstance(ingredients, list) or not all(isinstance(i, dict) for i in ingredients):
        return jsonify({'error': 'Ingredients must be a list of dictionaries'}), 400

    if not isinstance(steps, list) or not all(isinstance(i, dict) for i in steps):
        return jsonify({'error': 'Steps must be a list of dictionaries'}), 400

    recipe_ref = db.collection('recipes').document(recipe_id)
    recipe = recipe_ref.get()

    if recipe.exists:
        if recipe.to_dict().get('user_id') != current_user:
            return jsonify({'error': 'Unauthorized access to the recipe'}), 403

        recipe_ref.update({
            'recipe_name': recipe_name,
            'details': details,
            'duration': duration,
            'steps': steps,
            'ingredients': ingredients,
        })
        return jsonify({'msg': 'Recipe updated'}), 200

    return jsonify({'error': 'Recipe not found'}), 404

@app.route('/create_recipe', methods=['POST'])
@jwt_required()
def create_recipe():
    current_user = get_jwt_identity()

    if not current_user:
        return jsonify({'error': 'User ID is required'}), 400
    
    # if 'recipe_image' not in request.files:
    #     return jsonify({'error': 'No image provided'}), 400

    # file = request.files['recipe_image']

    # if file.filename == '':
    #     return jsonify({'error': 'No selected file'}), 400
    
    # Get JSON data from request
    data = request.get_json()

    # Extract recipe data
    recipe_name = data.get('recipe_name')
    # user_id = data.get('user_id')
    details = data.get('details')
    duration = data.get('duration')
    steps = data.get('steps')
    ingredients = data.get('ingredients')
    image_url = data.get('image_url')

    # Validate required fields
    if not all([recipe_name, details, duration, steps, ingredients]):
        return jsonify({'error': 'Missing required fields'}), 400

    # # Upload the image to Firebase Storage
    # blob = bucket.blob(f'recipe_images/{file.filename}')
    # blob.upload_from_file(file)

    # # Make the file publicly accessible
    # blob.make_public()

    date_created = date.today().strftime('%Y-%m-%d')

    # Create a new recipe document
    recipe_ref = db.collection('recipes').document()
    recipe_ref.set({
        'recipe_name': recipe_name,
        'user_id': current_user,
        'date': date_created,
        'details': details,
        'duration': duration,
        'steps': steps,
        'ingredients': ingredients,
        'image_url': image_url,
    })

    return jsonify({'success': True, 'message': 'Recipe created successfully', 'id': recipe_ref.id}), 201

@app.route('/upload-image', methods=['POST'])
def upload_image():
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    # Upload the image to Firebase Storage
    blob = bucket.blob(f'recipe_images/{file.filename}')
    blob.upload_from_file(file)

    # Make the file publicly accessible
    blob.make_public()

    # Return the public URL of the uploaded image
    return jsonify({'url': blob.public_url})

##others
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


"""Steps and calories"""
def get_dates_for_week(date):
    start_of_week = date - timedelta(days=date.weekday())
    return [start_of_week + timedelta(days=i) for i in range(7)]

def get_weeks_for_month(date):
    first_day_of_month = date.replace(day=1)
    days_in_month = (first_day_of_month.replace(month=date.month % 12 + 1, day=1) - timedelta(days=1)).day
    return [first_day_of_month + timedelta(days=7 * i) for i in range((days_in_month // 7) + 1)]

@app.route('/store_steps', methods=['POST'])
@jwt_required()
def store_steps():
    data = request.json
    user_id = get_jwt_identity()
    steps = data.get('steps')
    date_str = data.get('date')
    date = datetime.strptime(date_str, '%Y-%m-%d').date()
    
    steps_doc = steps_collection.document(user_id).collection('dates').document(date_str)
    steps_doc.set({'steps': steps})
    
    return jsonify({'success': True}), 200

@app.route('/store_calories', methods=['POST'])
@jwt_required()
def store_calories():
    data = request.json
    user_id = get_jwt_identity()
    calories = data.get('calories')
    date_str = data.get('date')
    date = datetime.strptime(date_str, '%Y-%m-%d').date()
    
    calories_doc = calories_collection.document(user_id).collection('dates').document(date_str)
    calories_doc.set({'calories': calories})
    
    return jsonify({'success': True}), 200


@app.route('/get_steps_summary', methods=['GET'])
@jwt_required()
def get_steps_summary():
    user_id = get_jwt_identity()

    # Use the current date
    today = datetime.now().date()
    current_year = today.year
    current_month = today.month

    # Determine the start and end dates for the current week
    start_of_week = today - timedelta(days=today.weekday())
    end_of_week = start_of_week + timedelta(days=6)
    
    # Determine the start and end dates for the current month
    start_of_month = datetime(current_year, current_month, 1).date()
    end_of_month = (start_of_month.replace(day=28) + timedelta(days=4)).replace(day=1) - timedelta(days=1)

    # Fetch weekly steps
    weekly_steps_data = []
    total_weekly_steps = 0
    current_date = start_of_week
    while current_date <= end_of_week:
        day_of_week = current_date.strftime('%A')  # Get the name of the day
        steps_doc = steps_collection.document(user_id).collection('dates').document(current_date.strftime('%Y-%m-%d')).get()
        if steps_doc.exists:
            steps = steps_doc.to_dict().get('steps', 0)
        else:
            steps = 0
        weekly_steps_data.append({
            'day_of_week': day_of_week,
            'date': current_date.strftime('%Y-%m-%d'),
            'count': steps
        })
        total_weekly_steps += steps
        current_date += timedelta(days=1)

    # Fetch monthly steps
    monthly_steps_data = []
    total_monthly_steps = 0
    current_date = start_of_month
    while current_date <= end_of_month:
        start_of_week = current_date - timedelta(days=current_date.weekday())
        end_of_week = start_of_week + timedelta(days=6)

        # Ensure end_of_week is not beyond end_of_month
        if end_of_week > end_of_month:
            end_of_week = end_of_month

        total_steps = 0
        week_current_date = start_of_week
        while week_current_date <= end_of_week:
            steps_doc = steps_collection.document(user_id).collection('dates').document(week_current_date.strftime('%Y-%m-%d')).get()
            if steps_doc.exists:
                total_steps += steps_doc.to_dict().get('steps', 0)
            week_current_date += timedelta(days=1)

        monthly_steps_data.append({
            'start_date': start_of_week.strftime('%Y-%m-%d'),
            'end_date': end_of_week.strftime('%Y-%m-%d'),
            'count': total_steps
        })
        total_monthly_steps += total_steps
        current_date = end_of_week + timedelta(days=1)

    # Prepare response
    response = {
        'weekly': {
            'data': weekly_steps_data,
            'total': total_weekly_steps
        },
        'monthly': {
            'data': monthly_steps_data,
            'total': total_monthly_steps
        }
    }

    return jsonify(response), 200


@app.route('/get_calories_summary', methods=['GET'])
@jwt_required()
def get_calories_summary():
    user_id = get_jwt_identity()

    # Use the current date
    today = datetime.now().date()
    current_year = today.year
    current_month = today.month

    # Determine the start and end dates for the current week
    start_of_week = today - timedelta(days=today.weekday())
    end_of_week = start_of_week + timedelta(days=6)
    
    # Determine the start and end dates for the current month
    start_of_month = datetime(current_year, current_month, 1).date()
    end_of_month = (start_of_month.replace(day=28) + timedelta(days=4)).replace(day=1) - timedelta(days=1)

    # Fetch weekly calories
    weekly_calories_data = []
    total_weekly_calories = 0
    current_date = start_of_week
    while current_date <= end_of_week:
        day_of_week = current_date.strftime('%A')  # Get the name of the day
        calories_doc = calories_collection.document(user_id).collection('dates').document(current_date.strftime('%Y-%m-%d')).get()
        if calories_doc.exists:
            calories = calories_doc.to_dict().get('calories', 0)
        else:
            calories = 0
        weekly_calories_data.append({
            'day_of_week': day_of_week,
            'date': current_date.strftime('%Y-%m-%d'),
            'count': calories
        })
        total_weekly_calories += calories
        current_date += timedelta(days=1)

    # Fetch monthly calories
    monthly_calories_data = []
    total_monthly_calories = 0
    current_date = start_of_month
    while current_date <= end_of_month:
        start_of_week = current_date - timedelta(days=current_date.weekday())
        end_of_week = start_of_week + timedelta(days=6)

        # Ensure end_of_week is not beyond end_of_month
        if end_of_week > end_of_month:
            end_of_week = end_of_month

        total_calories = 0
        week_current_date = start_of_week
        while week_current_date <= end_of_week:
            calories_doc = calories_collection.document(user_id).collection('dates').document(week_current_date.strftime('%Y-%m-%d')).get()
            if calories_doc.exists:
                total_calories += calories_doc.to_dict().get('calories', 0)
            week_current_date += timedelta(days=1)

        monthly_calories_data.append({
            'start_date': start_of_week.strftime('%Y-%m-%d'),
            'end_date': end_of_week.strftime('%Y-%m-%d'),
            'count': total_calories
        })
        total_monthly_calories += total_calories
        current_date = end_of_week + timedelta(days=1)

    # Prepare response
    response = {
        'weekly': {
            'data': weekly_calories_data,
            'total': total_weekly_calories
        },
        'monthly': {
            'data': monthly_calories_data,
            'total': total_monthly_calories
        }
    }

    return jsonify(response), 200



if __name__ == "__main__":
    app.run(debug=True)
