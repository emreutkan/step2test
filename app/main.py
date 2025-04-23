
import logging
from fastapi import FastAPI, HTTPException
from app.keyvault import KeyVaultClient

logging.basicConfig(level=logging.DEBUG,
                    format="%(asctime)s %(levelname)s %(name)s: %(message)s")
logger = logging.getLogger(__name__)

app = FastAPI(title="KeyVault Integration Demo")

key_vault_url = "https://group16vault.vault.azure.net/"
kv = KeyVaultClient(key_vault_url)

@app.get("/hello")
async def hello():
    try:
        logger.debug("GET /hello called — retrieving 'db-conn' secret")
        conn_str = kv.get_secret("db-conn")
        logger.info("Key Vault connection string retrieved successfully")
        return {"message": "Key Vault OK"}
    except Exception as e:
        logger.error("Error fetching secret: %s", e, exc_info=True)
        raise HTTPException(status_code=500, detail="Unable to fetch secret")

if __name__ == "__main__":
    import uvicorn
    logger.debug("Starting Uvicorn server")
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
