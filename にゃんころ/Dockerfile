# --- Base Stage: Build Environment ---
FROM python:3.12-alpine AS base

# --- Install dependencies for building ---
RUN apk add --no-cache build-base libffi-dev git curl

# --- Install Poetry ---
RUN python -m pip install --upgrade pip \
    && pip install poetry

# --- Set working directory ---
WORKDIR /app

# --- Copy dependency files ---
COPY pyproject.toml poetry.lock* ./

# --- Install Python dependencies (no root project) ---
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

# --- Copy the rest of the app ---
COPY . .

# --- Production Stage: smaller Lambda image ---
FROM python:3.12-alpine AS lambda

# --- Copy installed packages ---
COPY --from=base /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=base /app /app

WORKDIR /app

# --- Lambda entrypoint ---
CMD ["main.lambda_handler"]
