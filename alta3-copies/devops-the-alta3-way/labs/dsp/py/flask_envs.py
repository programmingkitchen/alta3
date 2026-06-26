import os
from flask import Flask

app = Flask(__name__)

app.config['DATABASE_URI'] = os.environ.get('MY_APP_DB_URI')
app.config['SECRET_KEY'] = os.getenv('MY_APP_SECRET_KEY', 'This is my secret key!')

# Define a route for the home page
@app.route('/')
def home():
    return f"My Database URI is => {app.config.get('DATABASE_URI')}, and my Secret Key is => {app.config.get('SECRET_KEY')}"

if __name__ == '__main__':
    app.run("0.0.0.0", 2224)
