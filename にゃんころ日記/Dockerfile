# ベースイメージ / Base image
FROM python:3.12-slim

# 作業ディレクトリ / Set workdir
WORKDIR /app

# Poetryインストール / Install Poetry
RUN pip install --no-cache-dir poetry

# 依存関係インストール / Install dependencies
COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false \
    && poetry install --no-root

# コードコピー / Copy bot code
COPY . .

# 環境変数をDockerfileで設定 / Optional defaults (can be overridden with --env-file)
ENV BOT_LOOP_HOURS=24

# ボット起動 / Run the bot
CMD ["poetry", "run", "python", "bot.py"]
