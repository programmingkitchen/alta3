#!/usr/bin/python3
"""Working with Environment Variables"""

import os

def main(): 
    os.environ["MY_VAR2"] = "Hello again, World!"

    var1 = os.environ.get("MY_VAR2")
    var2 = os.getenv("MY_VAR2")
    print(var1, var2) 

    var3 = os.getenv("ABSENT_ENV", "I'm defined!")
    print(var3)

if __name__ == "__main__":
    main()
