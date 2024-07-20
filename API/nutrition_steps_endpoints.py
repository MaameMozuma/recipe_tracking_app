from flask import request, jsonify
from api_config import app, db
import os
from dotenv import load_dotenv
from flask_jwt_extended import get_jwt_identity, jwt_required
import helpers as h
import requests

load_dotenv()

users = db.collection("user")



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
        'date': current_date
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
            'total_calories': total_calories
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
            'total_calories': total_calories
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
            'total_calories': total_calories
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

@app.route('/get_all_recipes', methods=['GET'])
def get_all_recipes():
    recipes_ref = db.collection('recipes')
    recipes = recipes_ref.stream()

    result = []
    for recipe in recipes:
        recipe_data = recipe.to_dict()
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

        result.append({
            'recipe_id': recipe.id,
            'recipe_name': recipe_data.get('recipe_name'),
            'ingredients': detailed_ingredients,
            'steps': steps,
            'total_calories': total_calories
        })

    return jsonify(result), 200

@app.route('/get_all_user_recipes', methods=['GET'])
@jwt_required()
def get_all_user_recipes():
    current_user = get_jwt_identity()
    recipes_ref = db.collection('recipes').where('user_id', '==', current_user)
    recipes = recipes_ref.stream()

    result = []
    for recipe in recipes:
        recipe_data = recipe.to_dict()
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

        result.append({
            'recipe_id': recipe.id,
            'recipe_name': recipe_data.get('recipe_name'),
            'ingredients': detailed_ingredients,
            'steps': steps,
            'total_calories': total_calories
        })

    return jsonify(result), 200

@app.route('/delete_recipe', methods=['DELETE'])
@jwt_required()
def delete_recipe():
    current_user = get_jwt_identity()
    recipe_name = request.args.get('recipe_name')

    if not current_user or not recipe_name:
        return jsonify({'error': 'User ID and recipe name are required'}), 400

    recipes_ref = db.collection('recipes').where('user_id', '==', current_user).where('recipe_name', '==', recipe_name)
    recipes = recipes_ref.stream()

    for recipe in recipes:
        recipe_ref = db.collection('recipes').document(recipe.id)
        recipe_ref.delete()
        return jsonify({'msg': 'Recipe deleted'}), 200

    return jsonify({'error': 'Recipe not found'}), 404

@app.route('/update_recipe', methods=['PUT'])
@jwt_required()
def update_recipe():
    current_user = get_jwt_identity()
    data = request.json
    recipe_name = data.get('recipe_name')
    ingredients = data.get('ingredients')
    steps = data.get('steps')

    if not current_user or not recipe_name or not ingredients or not steps:
        return jsonify({'error': 'Missing meal information'}), 400

    if not isinstance(ingredients, list) or not all(isinstance(i, dict) for i in ingredients):
        return jsonify({'error': 'Ingredients must be a list of dictionaries'}), 400

    if not isinstance(steps, list) or not all(isinstance(i, dict) for i in steps):
        return jsonify({'error': 'Steps must be a list of dictionaries'}), 400

    recipes_ref = db.collection('recipes').where('user_id', '==', current_user).where('recipe_name', '==', recipe_name)
    recipes = recipes_ref.stream()

    for recipe in recipes:
        recipe_ref = db.collection('recipes').document(recipe.id)
        recipe_ref.update({
            'ingredients': ingredients,
            'steps': steps
        })
        return jsonify({'msg': 'Recipe updated'}), 200

    return jsonify({'error': 'Recipe not found'}), 404

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



if __name__ == "__main__":
    app.run(debug=True)
