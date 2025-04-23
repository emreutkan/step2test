# app/keyvault.py

import logging
from azure.keyvault.secrets import SecretClient
from azure.identity import AzureCliCredential, DefaultAzureCredential, ChainedTokenCredential

logger = logging.getLogger(__name__)

class KeyVaultClient:
    def __init__(self, vault_url: str):
        logger.debug(f"Initializing KeyVaultClient for vault: {vault_url}")
        creds = ChainedTokenCredential(
            AzureCliCredential(),
            DefaultAzureCredential()
        )
        logger.debug("AzureCliCredential and DefaultAzureCredential chained")
        self.client = SecretClient(vault_url=vault_url, credential=creds)
        logger.debug("SecretClient created")

    def get_secret(self, name: str) -> str:
        logger.debug(f"Fetching secret '{name}' from Key Vault")
        secret = self.client.get_secret(name).value
        logger.debug(f"Successfully retrieved secret '{name}'")
        return secret
