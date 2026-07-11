import os

def test_env_variable():
    my_variable = os.getenv('MY_VARIABLE')
    assert my_variable == 'my_test_value'           # This is what we are hoping that our Docker Compose file sets as the value of our environment variable. 
