# Usar imagem base Python
FROM python:3.11-slim 

# Evita criação de .pyc e mantém logs em tempo real
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Instala dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*


# Copia e instala dependências do Python
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt 

# Copia o código da aplicação
COPY . .

# Expõe a porta 8000
EXPOSE 8000

# Comando para rodar a aplicação com Uvicorn (modo desenvolvimento com auto-reload)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
