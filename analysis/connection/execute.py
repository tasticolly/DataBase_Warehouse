import argparse
import os
import warnings

warnings.simplefilter(action="ignore")
import pandas as pd
import psycopg2 as pg
import sqlalchemy
from os import environ
from dataclasses import dataclass
from urllib.parse import quote


@dataclass
class Credentials:
    dbname: str = environ.get("POSTGRES_DB", "pg_db")
    host: str = environ.get("POSTGRES_HOST", "localhost")
    port: int = int(environ.get("POSTGRES_PORT", "5432")[-4:])
    user: str = environ.get("POSTGRES_USER", "postgres")
    password: str = environ.get("POSTGRES_PASSWORD", "postgres")


def _extract_credentials():
    return Credentials(
        dbname=os.getenv("DBNAME", Credentials.dbname),
        host=os.getenv("DBHOST", Credentials.host),
        port=os.getenv("DBPORT", Credentials.port),
        user=os.getenv("DBUSER", Credentials.user),
        password=os.getenv("DBPASSWORD", Credentials.password),
    )


def psycopg2_conn_string(creds=None):
    if not creds:
        creds = _extract_credentials()
    return f"""
        dbname='{creds.dbname}' 
        user='{creds.user}' 
        host='{creds.host}' 
        port='{creds.port}' 
        password='{creds.password}'
    """


def psycopg2_conn(conn_string=None):
    if not conn_string:
        conn_string = psycopg2_conn_string()
    return pg.connect(conn_string)


def psycopg2_execute_sql(sql, conn=None, verbose=False):
    if not conn:
        conn = psycopg2_conn()
    if verbose:
        df = pd.read_sql_query(sql, conn)
        print(pd)
        return df
    else:
        cursor = conn.cursor()
        cursor.execute(sql)
        conn.commit()


def sqlalchemy_conn_string(creds=None):
    if not creds:
        creds = _extract_credentials()
    return (
        "postgresql://"
        f"{creds.user}:{quote(creds.password)}@"
        f"{creds.host}:{creds.port}/{creds.dbname}"
    )


def sqlalchemy_conn(conn_string=None):
    if not conn_string:
        conn_string = sqlalchemy_conn_string()
    return sqlalchemy.create_engine(
        conn_string,
        pool_pre_ping=True,
        connect_args={
            "keepalives": 1,
            "keepalives_idle": 30,
            "keepalives_interval": 10,
            "keepalives_count": 5,
        },
    )


def execute_sql_to_df(conn, sql):
    return pd.read_sql(sql, con=conn)


def read_sql(filepath):
    with open(filepath, "r") as file:
        return file.read().rstrip()


def exec_sql(sql, verbose):
    return psycopg2_execute_sql(sql=sql, verbose=verbose)


def exec_sql_file(path, cat, verbose):
    import time

    time.sleep(1)
    sql = read_sql(path)
    if cat:
        print(sql)
    return exec_sql(sql, verbose)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--file", default="", dest="file", help="path to sql script to execute"
    )
    parser.add_argument(
        "--cat",
        default=False,
        dest="cat",
        action="store_true",
        help="output file content",
    )
    parser.add_argument("--sql", default="", dest="sql", help="sql script to execute")
    parser.add_argument(
        "--verbose",
        default=False,
        dest="verbose",
        action="store_true",
        help="output execution result",
    )
    args = parser.parse_args()

    if args.file:
        exec_sql_file(args.file, args.cat, args.verbose)

    if args.sql:
        exec_sql(args.sql, args.verbose)
