# pulling our base image
FROM python:3.9-slim                        

# establishing the working directory within the container
WORKDIR /app                                

# copying this current directory "." (here) to the working directory in the container
COPY . .                                       

# installing any dependencies (we need to add this file for our Flask dependency)
RUN pip install -r requirements.txt

# running this command within the container to start our Flask server
CMD python flasky.py    

# listens on TCP port 2224 at runtime
EXPOSE 2224
