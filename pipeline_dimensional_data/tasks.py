
import sys
import os
import configparser
parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.append(parent_dir)


import utils
#import config

import pandas as pd
import pyodbc


def insert_into_table(dimensional_cursor, sql_script_dir, table_name, sql_filename, start_date=None, end_date=None):
    try:
        # Load the SQL script
        sql_script = utils.load_query(sql_filename, sql_script_dir)
        
        # Append date filtering logic if `start_date` and `end_date` are provided
        if start_date and end_date:
            sql_script += f" WHERE transaction_date BETWEEN '{start_date}' AND '{end_date}'"

        # Execute the query
        dimensional_cursor.execute(sql_script)
        dimensional_cursor.commit()

        print(f"Data has been processed and inserted/updated in the {table_name} table.")
        return {'success': True}
    except Exception as e:
        print(f"Error while processing {table_name}: {e}")
        return {'success': False, 'error': str(e)}