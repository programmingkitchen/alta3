#!/usr/bin/python3
"""Setting Up a Simple Flask Server"""

from flask import Flask 
from flask import render_template

app = Flask(__name__) #<= creates an instance of a Flask server

@app.route("/") #<= defines our base URL
def index(): #<= this is the function tied to the decorator above
    return render_template("playground.html") #<= using the render_template module to render our html to the browser

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=2224, debug=True) #<= setting the debug to "True" allows us to see changes to our template without restarting our server
