from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from app.models import User
from app.database import get_db, init_db

app = FastAPI()

# Inicializa o banco ao iniciar a aplicação
@app.on_event("startup")
def on_startup():
    init_db()

@app.post("/criar")
def create_user(name: str, db: Session = Depends(get_db)):
    user = User(name=name)
    db.add(user)
    db.commit()
    db.refresh(user)
    return {"id": user.id, "name": user.name}

@app.get("/usuarios/")
def get_usuarios(db: Session = Depends(get_db)):
    return db.query(User).all()

@app.get("/")
def root():
    return {"message": "API FastAPI + MySQL está funcionando!"}
