import logging
import logging.config
import tasks
import os
import utils
from logging import getLogger


config_file_path = os.path.join(os.getcwd(), 'logging.conf')

# Modify
log_file = r'C:\\Users\\hasmik\\Downloads\\BI-GP2\\logs\\logs_dimensional_data_pipeline.txt'

# Configure logging from logging.py
logging.config.fileConfig(
        config_file_path, 
        defaults={'LOGFILE': log_file}
    )
logger = getLogger(__name__)


class DimensionalDataFlow:
    def __init__(self):
        self.execution_id = utils.uuid_generator()
        self.conn_ER = tasks.connect_db_create_cursor("db")

    def exec(self):
        # Creating tables
        # tasks.create_dimension_tables(self.conn_ER)
        tasks.create_table(self.conn_ER)


        #Ingesting data into the tables
        tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Categories','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimCategories')
        tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Customers','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimCustomers')
        tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Employees','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimEmployees')
        tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Products','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimProducts')
        tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Region','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimRegion')
        tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Shippers','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimShippers')
        tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Suppliers','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimSuppliers')
        tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Territories','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimTerritories')
        tasks.update_table(self.conn_ER, db_rel='ORDERS_RELATIONAL_DB',schema_rel='dbo', table_rel='', db_dim='ORDERS_DIMENSIONAL_DB', schema_dim='dbo', table_dim='FactOrders')
        self.conn_ER.close()

        # Log execution completion
        logger.info(f"Execution complete.  \n execution_id is [ {self.execution_id} ]")
