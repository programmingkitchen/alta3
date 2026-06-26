from flask import Flask
from flask import render_template

app = Flask(__name__) #<= creates an instance of a Flask server

@app.route("/") #<= defines our base URL
def index(): #<= this is the function tied to the decorator above
    return render_template("styling_practice.html") #<= this should render the NEW template we just made above.
    
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=2224, debug=True)
