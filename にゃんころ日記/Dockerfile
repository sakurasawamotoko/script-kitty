# Dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY bot.py /app/
RUN pip install --no-cache-dir discord.py

CMD ["python", "bot.py"]
