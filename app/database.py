import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from dotenv import load_dotenv

# Carrega o .env.local explicitamente
#load_dotenv(dotenv_path=".env.local")

# Carrega o .env explicitamente
load_dotenv()

# Pega variáveis do container
DB_USER = os.getenv("MYSQL_USER", "root")
DB_PASSWORD = os.getenv("MYSQL_ROOT_PASSWORD", 1234)
DB_HOST = os.getenv("DB_HOST", "db")         # <- chave: usa "db"
DB_PORT = os.getenv("DB_PORT", "3306")
DB_NAME = os.getenv("MYSQL_DATABASE", "test_db")

DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

engine = create_engine(DATABASE_URL, echo=True, future=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Cria as tabelas no início
Base = declarative_base()

# Dependência para criar e fechar sessão
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Cria as tabelas no banco, se não existirem
def init_db():
    Base.metadata.create_all(bind=engine)