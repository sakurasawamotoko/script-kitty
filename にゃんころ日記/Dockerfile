# ベースイメージ (Base image)
FROM python:3.12-alpine AS base

# 作業ディレクトリを作成 (Create working directory)
WORKDIR /app

# 必要パッケージのインストール (Install system dependencies)
RUN apk add --no-cache build-base libffi-dev git curl

# pip と Poetry をインストール (Install pip and Poetry)
RUN python -m pip install --upgrade pip \
    && pip install poetry

# 依存関係ファイルをコピー (Copy dependency files)
COPY pyproject.toml poetry.lock* /app/

# Poetryで依存関係インストール (Install dependencies with Poetry)
# プロジェクト自体はインストールしない (--no-root)
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --no-root

# アプリケーションコードをコピー (Copy application code)
COPY . /app

# Fargateタスク起動時に実行されるコマンド (Command to run the bot in Fargate)
CMD ["python", "main.py"]
