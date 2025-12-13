# にゃんころ/Dockerfile
FROM python:3.12-alpine AS base

WORKDIR /app

# Build dependencies
RUN apk add --no-cache build-base libffi-dev git curl

# Upgrade pip + install Poetry
RUN python -m pip install --upgrade pip \
    && pip install poetry

# Copy only dependency manifests first for caching
COPY pyproject.toml poetry.lock* /app/

# Install dependencies (production mode)
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --no-root

# Copy source code and tests
COPY . /app

# Lambda entrypoint
CMD ["python", "main.py"]
