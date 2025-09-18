FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY src/ /app

RUN printf '#!/usr/bin/env sh\ncurl -fsS http://127.0.0.1:8000/ >/dev/null || exit 1\n' > /healthcheck.sh && \
    chmod +x /healthcheck.sh

EXPOSE 8000

CMD ["gunicorn", "core.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]
