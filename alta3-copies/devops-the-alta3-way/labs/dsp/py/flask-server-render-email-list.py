#!/usr/bin/python3
"""Flask server to render email list"""

import csv

from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")

def index():
    email_list = []

    with open("emails.csv") as email_csv:
        reader = csv.reader(email_csv)
        for row in reader:
            email_list.append(row)

        return render_template("index.html", email_list=email_list)

if __name__ == "__main__":
    app.run("0.0.0.0", 2224, debug=True)
