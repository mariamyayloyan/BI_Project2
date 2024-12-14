# # Pipeline Configuration
# def set_input_folder(task_type):
#     if task_type == "create_table":
#         input_dir = 'C:\\Users\\hasmik\\Downloads\\BI-GP2\\infrastructure_initiation'
#     elif task_type == "update":
#         input_dir = 'C:\\Users\\hasmik\\Downloads\\BI-GP2\\pipeline_dimensional_data\\queries'
#     return input_dir

# sql_server_config = 'C:\\Users\\hasmik\\Downloads\\BI-GP2\\sql_server_config.cfg'
# print('##### Choekout config.py #####')

import os

# Define the base directory (project root or script location)
base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

# Pipeline Configuration
def set_input_folder(task_type):
    if task_type == "create_table":
        input_dir = os.path.join(base_dir, 'infrastructure_initiation')
    elif task_type == "update":
        input_dir = os.path.join(base_dir, 'pipeline_dimensional_data', 'queries')
    return input_dir

# SQL Server Configuration
sql_server_config = os.path.join(base_dir, 'sql_server_config.cfg')

# Define the relative path
input_dir = os.path.join(base_dir, "pipeline_dimensional_data", "queries")


print('##### Checkout config.py #####')