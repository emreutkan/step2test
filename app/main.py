# app/main.py

import logging
from fastapi import FastAPI, HTTPException
from app.database import Database

logging.basicConfig(level=logging.DEBUG,
                    format="%(asctime)s %(levelname)s %(name)s: %(message)s")
logger = logging.getLogger(__name__)

app = FastAPI(title="DB Connection Demo")

key_vault_url = "https://group16vault.vault.azure.net/"
db = Database(key_vault_url)

@app.get("/hello")
async def hello():
    logger.debug("GET /hello called — testing DB connection")
    if db.connect():
        db.disconnect()
        logger.info("DB connection test passed")
        return {"message": "database connected"}
    else:
        logger.error("DB connection test failed")
        raise HTTPException(status_code=500, detail="database connection failed")

