FROM python:3.9-slim as base

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

CMD ["main.lambda_handler"]

# --- Stage for Local Development ---

FROM base as local
CMD ["python", "src/main.py"]