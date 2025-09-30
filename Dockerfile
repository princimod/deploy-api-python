# Usar imagem base Python
FROM python:3.11-slim 

# Evita criação de .pyc e mantém logs em tempo real
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Instala dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*


# Copia e instala dependências do Python
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt 

# Copia o código da aplicação (melhor mover para o final)
COPY . /app 

# Define o diretório de trabalho
WORKDIR /app 

# Expõe a porta 8000
EXPOSE 8000

# Comando para rodar a aplicação com Uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

