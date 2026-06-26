const my_array = [1, 2, 3, 4]

for (let number of my_array) { // <= this is one approach which defines each item within the array as "number"
      if (number===3){ // <= the "is equal to" operator is "===", and "is not equal to" is "!=="
                console.log("three"); // <= often you'll find a semicolon (";") at the ends of lines, but for the most part they are optional in JS 
            } else {
                      console.log(number)
                  }
} // <= remembering to close up all your brackets and parenthesis is an important habit to establish in JavaScript

