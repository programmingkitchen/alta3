# This base image container is avail on hub.docker.com
# it has python 3.7 avail on Alpine Linux, a minimalist Linux distro
FROM python:alpine3.7

# this "moves" the application/directory (`.` means "this directory we are in" => into /app in the container image) into the container image.
COPY . /app

#this sets the directory copied above as the working directory
WORKDIR /app

# Use Python package installer to install the Flask library to our image
RUN pip install -r requirements.txt

# container is exposed on port 5000
EXPOSE 5000
CMD python ./dune.py
