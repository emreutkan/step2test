# app/main.py

from fastapi import FastAPI

app = FastAPI(title="Hello Endpoint Demo")

@app.get("/hello")
async def hello():
    return {"message": "Hello, world!"}
