# app/database.py

import logging
import psycopg2
from app.keyvault import KeyVaultClient
import re

logger = logging.getLogger(__name__)

class Database:
    def __init__(self, key_vault_url):
        self.kv_client = KeyVaultClient(key_vault_url)
        self.connection = None

    def connect(self):
        try:
            logger.debug("Retrieving DB credentials from Key Vault")
            db_conn = self.kv_client.get_secret("db-conn")
            db_user = self.kv_client.get_secret("db-user")
            db_pass = self.kv_client.get_secret("db-pass")

            logger.debug("Parsing connection string")
            pattern = r"postgresql://(.+)@(.+):(\d+)/(.+)"
            match = re.match(pattern, db_conn)
            username, host, port, dbname = match.groups()

            logger.debug(f"Connecting to DB host={host} db={dbname}")
            self.connection = psycopg2.connect(
                host=host,
                database=dbname,
                user=db_user,
                password=db_pass,
                port=port,
                sslmode="require"
            )
            logger.info("Database connection established")
            return True

        except Exception as e:
            logger.error(f"Database connection error: {e}", exc_info=True)
            return False

    def disconnect(self):
        if self.connection:
            self.connection.close()
            logger.info("Database connection closed")
            self.connection = None
