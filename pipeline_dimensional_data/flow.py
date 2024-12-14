
from . import config
from . import tasks
import logging
import utils
from .config import sql_server_config
from logging1 import log_message_dim


class DimensionalDataFlow:
    def __init__(self):
        # Generate a unique execution ID
        self.execution_id = utils.generate_uuid()
        self.logger = logging.getLogger('DimensionalDataFlowLogger')
        self.logger.info(f'Dimensional database connection initialized with execution_id: {self.execution_id}')

        # Initialize database connection
        self.conn_dimensional = utils.connect_db_create_cursor(sql_server_config, 'DimensionalDatabase')
        log_message_dim('info', 'Dimensional database connection initialized', self.execution_id)

    def close_connection(self):
        # Close the database connection
        self.conn_dimensional.close()
        log_message_dim('info', 'Database connections closed', self.execution_id)



    def exec(self, start_date=None, end_date=None):
        """
        Sequentially executes tasks to populate and update dimensional data tables.

        Args:
            start_date (str): Optional start date for data processing.
            end_date (str): Optional end date for data processing.
        """
        log_message_dim('info', 'Starting execution of dimensional data flow', self.execution_id)

        table_operations = [
            {"table_name": "DimCategories", "sql_filename": "update_dim_categories"},
            {"table_name": "DimCustomers", "sql_filename": "update_dim_customers"},
            {"table_name": "DimEmployees", "sql_filename": "update_dim_employees"},
            {"table_name": "DimProducts", "sql_filename": "update_dim_products"},
            {"table_name": "DimRegion", "sql_filename": "update_dim_region"},
            {"table_name": "DimShippers", "sql_filename": "update_dim_shippers"},
            {"table_name": "DimSuppliers", "sql_filename": "update_dim_supplier"},
            {"table_name": "DimTerritories", "sql_filename": "update_dim_territories"},
            {"table_name": "FactError", "sql_filename": "update_fact_error"},
            {"table_name": "Fact", "sql_filename": "update_fact"}
        ]

        try:
            for operation in table_operations:
                result = tasks.insert_into_table(
                    self.conn_dimensional,
                    config.input_dir,
                    operation["table_name"],
                    operation["sql_filename"],
                    start_date=start_date,
                    end_date=end_date  # Pass date parameters
                )

                if result['success']:
                    log_message_dim('info', f"{operation['table_name']} table updated successfully.", self.execution_id)
                else:
                    log_message_dim('error', f"Failed to update {operation['table_name']} table: {result.get('error')}", self.execution_id)
                    break  # Stop further execution if a failure occurs

            log_message_dim('info', 'Completed execution of dimensional data flow', self.execution_id)

        except Exception as e:
            log_message_dim('error', f'Error during execution: {e}', self.execution_id)
            raise