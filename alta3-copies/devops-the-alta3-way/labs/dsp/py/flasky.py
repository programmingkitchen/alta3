#!/usr/bin/python3

from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
        return "<h1>This is your Flask app.</h1>"

    if __name__ == "__main__":
            app.run("0.0.0.0", 2224)
