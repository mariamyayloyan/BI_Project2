import os
import pyodbc
import logging
from pipeline_dimensional_data.utils import read_sql_script

# Set up logging for tasks
logging.basicConfig(
    format='%(asctime)s [%(levelname)s] %(message)s',
    level=logging.INFO
)

def create_connection():
    # Load the connection configuration from the config file
    connection_str = 'DRIVER={SQL Server};SERVER=your_server;DATABASE=ORDER_DDS;UID=your_username;PWD=your_password'
    return pyodbc.connect(connection_str)

def create_tables():
    """Create necessary tables for the dimensional database."""
    try:
        with create_connection() as conn:
            cursor = conn.cursor()
            script_path = os.path.join('infrastructure_initiation', 'dimensional_db_creation.sql')
            query = read_sql_script(script_path)
            cursor.execute(query)
            conn.commit()
        logging.info("Dimensional database tables created successfully.")
        return {'success': True}
    except Exception as e:
        logging.error(f"Error creating tables: {e}")
        return {'success': False}

def update_dimensions(start_date: str, end_date: str):
    """Ingest data into dimension tables."""
    try:
        with create_connection() as conn:
            cursor = conn.cursor()
            # Define each dimension update script here
            scripts = [
                'update_dim_categories.sql',
                'update_dim_customers.sql',
                'update_dim_employees.sql',
                'update_dim_products.sql',
                'update_dim_region.sql',
                'update_dim_shippers.sql',
                'update_dim_supplier.sql',
                'update_dim_territories.sql'
            ]

            for script in scripts:
                script_path = os.path.join('pipeline_dimensional_data', 'queries', script)
                query = read_sql_script(script_path)
                cursor.execute(query, start_date=start_date, end_date=end_date)
                conn.commit()

        logging.info("Dimension tables updated successfully.")
        return {'success': True}
    except Exception as e:
        logging.error(f"Error updating dimension tables: {e}")
        return {'success': False}

def update_fact(start_date: str, end_date: str):
    """Update the fact table from staging and dimension tables."""
    try:
        with create_connection() as conn:
            cursor = conn.cursor()
            script_path = os.path.join('pipeline_dimensional_data', 'queries', 'update_fact.sql')
            query = read_sql_script(script_path)
            cursor.execute(query, start_date=start_date, end_date=end_date)
            conn.commit()
        logging.info("Fact table updated successfully.")
        return {'success': True}
    except Exception as e:
        logging.error(f"Error updating fact table: {e}")
        return {'success': False}

def update_fact_error(start_date: str, end_date: str):
    """Ingest faulty rows into the fact error table."""
    try:
        with create_connection() as conn:
            cursor = conn.cursor()
            script_path = os.path.join('pipeline_dimensional_data', 'queries', 'update_fact_error.sql')
            query = read_sql_script(script_path)
            cursor.execute(query, start_date=start_date, end_date=end_date)
            conn.commit()
        logging.info("Fact error table updated successfully.")
        return {'success': True}
    except Exception as e:
        logging.error(f"Error updating fact error table: {e}")
        return {'success': False}
