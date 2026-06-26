#!/usr/bin/python3
import unittest
import sqlite3
from flask import Flask, redirect, url_for
from email_reg import get_db_connection, get_subscribers, app

class DatabaseConnectionTest(unittest.TestCase):
    def test_get_db_connection(self):
        with app.app_context():
            conn = get_db_connection()
            self.assertIsInstance(conn, sqlite3.Connection)
            conn.close()

class SubscriberManagementTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        with app.app_context():
            conn = get_db_connection()
            c = conn.cursor()
            c.execute('''CREATE TABLE IF NOT EXISTS subscribers (email text)''')
            c.execute("DELETE FROM subscribers")  # Clear any existing data
            c.execute("INSERT INTO subscribers VALUES ('test1@example.com')")
            conn.commit()
            c.close()
            conn.close()

    def setUp(self):
        self.app = app.test_client()

    def test_get_subscribers(self):
        with app.app_context():
            subscribers = get_subscribers()
        self.assertEqual(len(subscribers), 1)
        self.assertEqual(subscribers[0]['email'], 'test1@example.com')

if __name__ == '__main__':
    unittest.main()
