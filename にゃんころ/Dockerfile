# --- Base Stage: Build Environment / ビルド環境 ---
FROM python:3.12-alpine AS base

# --- ARGs for Lambda environment variables / Lambda用環境変数 ---
ARG DISCORD_BOT_TOKEN
ARG DISCORD_GUILD_ID
ARG DISCORD_ROLE_DISCORDBOOSTER
ARG DISCORD_ROLE_TWITCHSUB
ARG DISCORD_ROLE_NEKOBAJI
ARG DISCORD_ROLE_KASUTO
ARG DISCORD_ROLE_SEITOKAIYAKUIN
ARG DISCORD_ROLE_GAKKYUIIN
ARG DISCORD_ROLE_MANGAKA
ARG SCRIPT_KITTY_OPENAI_KEY

# --- Set ENV for Lambda / Lambda環境用にENV設定 ---
ENV DISCORD_BOT_TOKEN=${DISCORD_BOT_TOKEN}
ENV DISCORD_GUILD_ID=${DISCORD_GUILD_ID}
ENV DISCORD_ROLE_DISCORDBOOSTER=${DISCORD_ROLE_DISCORDBOOSTER}
ENV DISCORD_ROLE_TWITCHSUB=${DISCORD_ROLE_TWITCHSUB}
ENV DISCORD_ROLE_NEKOBAJI=${DISCORD_ROLE_NEKOBAJI}
ENV DISCORD_ROLE_KASUTO=${DISCORD_ROLE_KASUTO}
ENV DISCORD_ROLE_SEITOKAIYAKUIN=${DISCORD_ROLE_SEITOKAIYAKUIN}
ENV DISCORD_ROLE_GAKKYUIIN=${DISCORD_ROLE_GAKKYUIIN}
ENV DISCORD_ROLE_MANGAKA=${DISCORD_ROLE_MANGAKA}
ENV SCRIPT_KITTY_OPENAI_KEY=${SCRIPT_KITTY_OPENAI_KEY}

# --- Install dependencies for building / ビルドに必要な依存関係をインストール ---
RUN apk add --no-cache build-base libffi-dev git curl

# --- Install Poetry / Poetryをインストール ---
RUN python -m pip install --upgrade pip \
    && pip install poetry

# --- Set working directory / 作業ディレクトリを設定 ---
WORKDIR /app

# --- Copy dependency files / 依存関係ファイルをコピー ---
COPY にゃんころ/pyproject.toml /app/
COPY にゃんころ/poetry.lock* /app/

# --- Install Python dependencies with Poetry / Poetryで依存関係をインストール ---
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

# --- Copy the rest of the app / アプリの残りのファイルをコピー ---
COPY にゃんころ/ /app/

# --- Production stage: smaller Lambda image / 本番用ステージ: Lambda用に小さく ---
FROM python:3.12-alpine AS lambda

# --- Copy from builder / ビルド済みからコピー ---
COPY --from=base /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=base /app /app

WORKDIR /app

# --- Lambda entrypoint / Lambdaエントリーポイント ---
CMD ["main.lambda_handler"]

# --- Local development stage / ローカル開発用ステージ ---
FROM base AS local
WORKDIR /app
CMD ["poetry", "run", "python", "src/main.py"]
