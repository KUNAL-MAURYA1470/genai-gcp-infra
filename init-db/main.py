import asyncio
import os

import asyncpg

DB_HOST = os.getenv("DB_HOST")
DB_USER = os.getenv("DB_USER")
DB_NAME = os.getenv("DB_NAME")
DB_PASS = os.getenv("DB_PASS")
APP_USER = os.getenv("APP_USER")


async def main():
    print("Running init-db job...")
    sys_conn = await asyncpg.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASS,
        database=DB_NAME,
        ssl="require",
    )
    print("Granting privileges on database...")
    print("Granting privileges on public schema...")
    print("Creating extension...")
    await sys_conn.execute(
        f"""
        GRANT ALL PRIVILEGES ON DATABASE "{DB_NAME}" TO "{APP_USER}";
        GRANT ALL ON SCHEMA public TO "{APP_USER}";
        CREATE EXTENSION IF NOT EXISTS vector;
        """
    )
    await sys_conn.close()
    print("Done")


if __name__ == "__main__":
    asyncio.run(main())
