#!/usr/bin/python3
"""Testing File for greeting.py"""

import unittest
import greeting

class GreetingTest(unittest.TestCase):
        def test_create_greeting(self):
            result = greeting.create_greeting("Hello", "Anyone") # <= This time we need to access the function through the import with dot notation.
            self.assertEqual(result, "Hello, Anyone!")

if __name__ == '__main__':
        unittest.main()
