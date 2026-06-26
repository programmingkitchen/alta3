#!/usr/bin/python3
"""Python Script for Fuzz Testing"""

def get_name():
    return input("What is your name?")

def get_age():
    return int(input("What is your age?"))

def process_name_age(name, age):
    if age > 0 and age < 110:
        return f"Hello, {name}. Your age is verified."
    else:
        return f"I'm sorry, {name}, but I cannot verify that age."

def main():
    print(process_name_age(get_name(),get_age()))

if __name__ == "__main__":
    main()
