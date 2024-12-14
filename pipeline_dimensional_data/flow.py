# import logging
# import logging.config
# import tasks
# import os
# import utils
# from logging import getLogger
# # from . import config
# # from . import tasks
# # import logging
# # import utils
# # from .config import sql_server_config
# # from logging1 import log_message_dim


# config_file_path = os.path.join(os.getcwd(), 'logging.conf')

# log_file = "logs/logs_dimensional_data_pipeline.txt"
# # Modify
# #log_file = r'C:\\Users\\hasmik\\Downloads\\BI-GP2\\logs\\logs_dimensional_data_pipeline.txt'

# # Configure logging from logging.py
# logging.config.fileConfig(
#         config_file_path, 
#         defaults={'LOGFILE': log_file}
#     )
# logger = getLogger(__name__)


# class DimensionalDataFlow:
#     def __init__(self):
#         self.execution_id = utils.uuid_generator()
#         self.conn_ER = tasks.connect_db_create_cursor(['DimensionalDatabase'])

#     def exec(self):
#         # Creating tables
#         # tasks.create_dimension_tables(self.conn_ER)
#         tasks.create_table(self.conn_ER)


#         #Ingesting data into the tables
#         tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Categories','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimCategories')
#         tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Customers','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimCustomers')
#         tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Employees','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimEmployees')
#         tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Products','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimProducts')
#         tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Region','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimRegion')
#         tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Shippers','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimShippers')
#         tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Suppliers','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimSuppliers')
#         tasks.update_table(self.conn_ER, 'ORDERS_RELATIONAL_DB','dbo','Territories','ORDERS_DIMENSIONAL_DB', 'dbo', 'DimTerritories')
#         tasks.update_table(self.conn_ER, db_rel='ORDERS_RELATIONAL_DB',schema_rel='dbo', table_rel='', db_dim='ORDERS_DIMENSIONAL_DB', schema_dim='dbo', table_dim='FactOrders')
#         self.conn_ER.close()

#         # Log execution completion
#         logger.info(f"Execution complete.  \n execution_id is [ {self.execution_id} ]")



from . import config
from . import tasks
import logging
import utils
from .config import sql_server_config
from logging1 import log_message_dim


class DimensionalDataFlow:
    def __init__(self):
        self.execution_id = utils.generate_uuid()
        self.logger = logging.getLogger('DimensionalDataFlowLogger')
        self.logger.info(f'Dimensional database connection initialized with execution_id: {self.execution_id}')

        self.conn_dimensional = utils.connect_db_create_cursor(sql_server_config, 'DimensionalDatabase')
        log_message_dim('info', 'Dimensional database connection initialized', self.execution_id)

        
    def close_connection(self):
        self.conn_dimensional.close()
        log_message_dim('info', 'Database connections closed', self.execution_id)

    def exec(self):
        log_message_dim('info', 'Starting execution of dimensional data flow', self.execution_id)

        try:
            tasks.insert_into_dim_categories(self.conn_dimensional, config.input_dir)
            log_message_dim('info', 'DimCategories table updated successfully.', self.execution_id)

            tasks.insert_into_dim_customers(self.conn_dimensional, config.input_dir)
            log_message_dim('info', 'DimCustomers table updated successfully.', self.execution_id)

            tasks.insert_into_dim_employees(self.conn_dimensional, config.input_dir)
            log_message_dim('info', 'DimEmployees table updated successfully.', self.execution_id)

            tasks.insert_into_dim_products(self.conn_dimensional, config.input_dir)
            log_message_dim('info', 'DimProducts table updated successfully.', self.execution_id)

            tasks.insert_into_dim_region(self.conn_dimensional, config.input_dir)
            log_message_dim('info', 'DimRegion table updated successfully.', self.execution_id)

            tasks.insert_into_dim_shippers(self.conn_dimensional, config.input_dir)
            log_message_dim('info', 'DimShippers table updated successfully.', self.execution_id)

            tasks.insert_into_dim_suppliers(self.conn_dimensional, config.input_dir)
            log_message_dim('info', 'DimSuppliers table updated successfully.', self.execution_id)

            tasks.insert_into_dim_territories(self.conn_dimensional, config.input_dir)
            log_message_dim('info', 'DimTerritories table updated successfully.', self.execution_id)

            tasks.insert_into_fact_error(self.conn_dimensional, config.input_dir)
            log_message_dim('info', 'Fact Error table updated successfully.', self.execution_id)

            tasks.insert_into_fact(self.conn_dimensional, config.input_dir)
            log_message_dim('info', 'FactOrders table updated successfully.', self.execution_id)

            log_message_dim('info', 'Completed execution of dimensional data flow', self.execution_id)
        except Exception as e:
            log_message_dim('error', f'Error during execution: {e}', self.execution_id)
            raise
