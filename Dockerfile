FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# FIX: Using Capital 'C' and 'V' to match your Windows folders
COPY Config/entrypoint.sh /entrypoint.sh
COPY Volguard/volguard.py /app/

RUN chmod +x /entrypoint.sh

RUN groupadd -g 1000 volguard && useradd -u 1000 -g 1000 volguard
USER volguard

ENTRYPOINT ["/entrypoint.sh"]
