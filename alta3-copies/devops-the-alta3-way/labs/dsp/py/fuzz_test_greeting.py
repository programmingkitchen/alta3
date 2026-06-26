#!/usr/bin/python3
"""Fuzz Tesing/Test Suite for greeting.py"""


import unittest
import random
from greeting import process_name_age

class FuzzTest(unittest.TestCase):
    def test_typical_inputs(self):
        typical_inputs = [
            ("Alice", 25),
            ("Bob", 50),
            ("Charlie", 18),
            ("Eve", 99)
        ]
        for name, age in typical_inputs:
            with self.subTest(name=name, age=age):
                output = process_name_age(name, age)
                self.assertEqual(output, f"Hello, {name}. Your age is verified.")

    def test_edge_cases(self):
        edge_cases = [
            ("", 25),  # Empty name
            ("John", 0),  # Minimum age
            ("Jane", 111),  # Maximum age
            ("Max", -5)  # Negative age
        ]
        for name, age in edge_cases:
            with self.subTest(name=name, age=age):
                output = process_name_age(name, age)
                self.assertEqual(output, f"I'm sorry, {name}, but I cannot verify that age.")

    def test_random_age(self):
        for _ in range(5):  # Perform 5 fuzz tests
            name = "John"  # Use a fixed name for this test
            age = random.randint(-1000, 1000)
            with self.subTest(name=name, age=age):
                output = process_name_age(name, age)
                if age > 0 and age < 100:
                    self.assertEqual(output, f"Hello, {name}. Your age is verified.")
                else:
                    self.assertEqual(output, f"I'm sorry, {name}, but I cannot verify that age.")

# Run the test suite
if __name__ == "__main__":
    unittest.main()
