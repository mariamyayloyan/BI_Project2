# flow.py

import logging
from pipeline_dimensional_data.tasks import create_tables, update_dimensions, update_fact, update_fact_error
from utils import generate_uuid

# Set up logging for the class
logging.basicConfig(
    filename='logs/logs_dimensional_data_pipeline.txt',
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s'
)

class DimensionalDataFlow:
    def __init__(self):
        # Generate a unique execution ID for every instance of this class
        self.execution_id = generate_uuid()
        self.logger = logging.getLogger(__name__)
        self.logger.info(f"Initializing DimensionalDataFlow with execution_id: {self.execution_id}")

    def exec(self, start_date: str, end_date: str):
        """
        Executes tasks in sequence with the given start_date and end_date.
        
        :param start_date: The starting date as a string.
        :param end_date: The ending date as a string.
        """
        tasks_successful = True
        self.logger.info(f"Execution started with ID {self.execution_id} from {start_date} to {end_date}")

        # Execute and log each task result
        try:
            # Task 1: Create tables
            result = create_tables()
            self.logger.info(f"Task: Create Tables - Success: {result['success']}")
            if not result['success']:
                tasks_successful = False

            # Task 2: Update dimension tables
            if tasks_successful:
                result = update_dimensions(start_date, end_date)
                self.logger.info(f"Task: Update Dimensions - Success: {result['success']}")
                if not result['success']:
                    tasks_successful = False

            # Task 3: Update fact table
            if tasks_successful:
                result = update_fact(start_date, end_date)
                self.logger.info(f"Task: Update Fact Table - Success: {result['success']}")
                if not result['success']:
                    tasks_successful = False

            # Task 4: Update fact error table
            if tasks_successful:
                result = update_fact_error(start_date, end_date)
                self.logger.info(f"Task: Update Fact Error Table - Success: {result['success']}")
                if not result['success']:
                    tasks_successful = False

        except Exception as e:
            self.logger.error(f"Execution with ID {self.execution_id} failed due to: {str(e)}")
            tasks_successful = False

        if tasks_successful:
            self.logger.info(f"Execution with ID {self.execution_id} completed successfully.")
        else:
            self.logger.warning(f"Execution with ID {self.execution_id} did not complete all tasks successfully.")
