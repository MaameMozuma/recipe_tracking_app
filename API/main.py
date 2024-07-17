from flask import request
import functions_framework
from api_config import app, db

## Import other endpoints
import usergoals_endpoints
import nutrition_steps_endpoints
import account_endpoints

@functions_framework.http
def main_entry(request):
    with app.request_context(request.environ):
        response = app.full_dispatch_request()
        return response

if __name__ == "__main__":
    app.run(debug=True)
