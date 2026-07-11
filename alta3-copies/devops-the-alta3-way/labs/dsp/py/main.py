from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    my_variable = os.getenv('MY_VARIABLE', 'default_value')  # the second argument is a default value if the environment variable isn't set. 
    return f"Hello, {my_variable}!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=2224)
