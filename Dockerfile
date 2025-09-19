# stage 1: builder (instala dependências)
FROM python:3.11-slim AS builder
WORKDIR /app

# instalação de dependências de sistema (mínimo)
RUN apt-get update && apt-get install -y --no-install-recommends gcc build-essential \
    && rm -rf /var/lib/apt/lists/*

# copiar requirements e instalar
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip wheel --no-cache-dir --no-deps -r requirements.txt -w /wheels

# stage 2: runtime
FROM python:3.11-slim
WORKDIR /app

# copiar wheels e instalar (mais rápido e sem ferramentas de build)
COPY --from=builder /wheels /wheels
RUN pip install --no-cache /wheels/*

# copiar código
COPY app ./app

EXPOSE 8000
ENV PYTHONUNBUFFERED=1

# usar gunicorn com uvicorn workers para produção
CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "app.main:app", "-b", "0.0.0.0:8000", "--workers", "1"]
