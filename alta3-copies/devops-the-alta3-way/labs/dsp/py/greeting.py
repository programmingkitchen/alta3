#!/usr/bin/python3
"""Greeting Generator/Testing"""

import random

def create_greeting(greeting, name):
    return greeting + "," + name + "!" #<= How will this concatenate?

def main():
    greeting = random.choice(["Hello", "Howdy", "Yo", "What up"])
    name = input("What is your name? ")
    print(create_greeting(greeting, name))

if __name__ == "__main__":
    main()
