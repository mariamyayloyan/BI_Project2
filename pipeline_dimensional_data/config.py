# Pipeline Configuration
def set_input_folder(task_type):
    if task_type == "create_table":
        input_dir = 'C:\\Users\\hasmik\\Downloads\\BI-GP2\\infrastructure_initiation'
    elif task_type == "update":
        input_dir = 'C:\\Users\\hasmik\\Downloads\\BI-GP2\\pipeline_dimensional_data\\queries'
    return input_dir

sql_server_config = 'C:\\Users\\hasmik\\Downloads\\BI-GP2\\sql_server_config.cfg'
print('##### Choekout config.py #####')
