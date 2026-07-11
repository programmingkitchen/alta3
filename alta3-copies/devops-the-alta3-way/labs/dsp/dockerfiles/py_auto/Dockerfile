FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
COPY requirements-test.txt .

RUN pip install -r requirements.txt
RUN pip install -r requirements-test.txt

COPY . .

CMD [ "python", "main.py" ]
