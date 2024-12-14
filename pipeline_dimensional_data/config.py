
import os

base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

# Pipeline Configuration
def set_input_folder(task_type):
    if task_type == "create_table":
        input_dir = os.path.join(base_dir, 'infrastructure_initiation')
    elif task_type == "update":
        input_dir = os.path.join(base_dir, 'pipeline_dimensional_data', 'queries')
    return input_dir

creation_dir = os.path.join(base_dir, "infrastructure_initiation", "dimensional_db_creation.sql")

creation_tables = os.path.join(base_dir, "infrastructure_initiation", "dimensional_db_table_creation.sql")

creation_staging_tables = os.path.join(base_dir, "infrastructure_initiation", "staging_raw_table_creation.sql")

# SQL Server Configuration
sql_server_config = os.path.join(base_dir, 'sql_server_config.cfg')

# Define the relative path
input_dir = os.path.join(base_dir, "pipeline_dimensional_data", "queries")


print('##### Checkout config.py #####')