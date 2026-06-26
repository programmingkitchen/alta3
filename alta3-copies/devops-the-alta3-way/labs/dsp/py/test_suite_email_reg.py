#!/usr/bin/python3
"""Email Registration - Flask"""

from flask import Flask, render_template, request, redirect, url_for
import sqlite3

app = Flask(__name__)

# SQLite database initialization
def get_db_connection():
    conn = sqlite3.connect('emails.db')
    conn.row_factory = sqlite3.Row
    return conn

def create_table():
    conn = get_db_connection()
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS subscribers (email text)''')
    conn.commit()
    c.close()
    conn.close()

def get_subscribers():
    conn = get_db_connection()
    c = conn.cursor()
    c.execute("SELECT * FROM subscribers")
    subscribers = c.fetchall()
    c.close()
    conn.close()
    return subscribers

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        email = request.form['email']
        if email:
            conn = get_db_connection()
            c = conn.cursor()
            c.execute("INSERT INTO subscribers VALUES (?)", (email,))
            conn.commit()
            c.close()
            conn.close()
            return redirect(url_for('index'))
    subscribers = get_subscribers()
    return render_template('index.html', subscribers=subscribers)

if __name__ == '__main__':
    create_table()
    app.run(host='0.0.0.0', port=5000
    )
