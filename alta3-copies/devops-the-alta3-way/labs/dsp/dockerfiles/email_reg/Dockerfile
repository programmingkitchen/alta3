# pulling our base image
FROM python:3.8-alpine   

# establishing the working directory within the container
WORKDIR /app

# copying from the local directory to the container working directory
COPY . .

# installing our requirements; we need to create this!
RUN pip install --no-cache-dir -r requirements.txt

# running our Flask server within the container
CMD ["python", "email_reg.py"]
