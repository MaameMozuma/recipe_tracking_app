from __main__ import app, jwt_required, get_jwt_identity
from __main__ import jsonify, users
import helpers as h
from flask import request, jsonify


@app.route('/set_goals', methods=['PATCH'])
@jwt_required()
def set_goals():
    current_user = get_jwt_identity()

    # Get user document
    users_ref = users.document(current_user)

    status, goals = h.verify_and_return_goals(request)
    print(goals)

    # Set a field in the document
    if status:
        steps = goals['steps']
        calories = goals['calories']
        users_ref.set({
            'steps': steps ,
            'calories' : calories
        }, merge = True)
        return jsonify(f"{current_user} calories set to {calories}, steps set to {steps}"), 200

    else:
        return jsonify({"msg":"failed to update steps"}), 500


