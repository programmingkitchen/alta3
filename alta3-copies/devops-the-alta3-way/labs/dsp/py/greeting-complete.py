import random
import unittest

class GreetingTest(unittest.TestCase):
    def test_create_greeting(self):
        result = create_greeting("Hello", "Someone")
        self.assertEqual(result, "Hello, Someone!")

def create_greeting(greeting, name):
    return greeting + "," + name + "!"

def main():
    greeting = random.choice(["Hello", "Howdy", "Yo", "What up"])
    name = input("What is your name? ")
    print(create_greeting(greeting, name))

if __name__ == "__main__":
    main()
    unittest.main()
