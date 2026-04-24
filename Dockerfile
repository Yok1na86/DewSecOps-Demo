
FROM python:3.11-slim AS builder

WORKDIR /app


RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --user --no-cache-dir -r requirements.txt


FROM python:3.11-slim

WORKDIR /app

RUN useradd -m appuser


COPY --from=builder /root/.local /home/appuser/.local
COPY . .


RUN chown -R appuser:appuser /app

USER appuser


ENV PATH=/home/appuser/.local/bin:$PATH


EXPOSE 5000

CMD ["python", "app.py"]

