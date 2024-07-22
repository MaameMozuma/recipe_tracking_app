from flask import request, jsonify, render_template, render_template_string
from api_config import app, db, bucket
import os
from dotenv import load_dotenv
from flask_jwt_extended import get_jwt_identity, jwt_required
import helpers as h
import requests
from datetime import datetime, date



load_dotenv()

users = db.collection("user")

@app.route('/share_recipe/<recipe_id>', methods=['GET'])
def share_recipe(recipe_id):
    # Assuming db is already set up and available
    recipe_ref = db.collection('recipes').document(recipe_id)
    recipe = recipe_ref.get().to_dict()

    # Handle non-existent recipe
    if not recipe:
        return jsonify({'error': 'Recipe not found'}), 404

    # Read the template file content
    template_path = os.path.join(os.path.dirname(__file__), 'recipe_card.html')
    with open(template_path) as file:
        template_content = file.read()

    # Render the template with the recipe data
    return render_template_string(template_content, data=recipe)






