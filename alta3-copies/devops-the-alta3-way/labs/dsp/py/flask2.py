#!/usr/bin/python3
"""Flask Server #2"""

from flask import Flask, render_template

app = Flask(__name__)

@app.route("/flask2")
def index():
        return render_template("flask2_template.html")

    if __name__ == "__main__":
            app.run("0.0.0.0", 9002)
