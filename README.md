# Project Overview

This project focuses on the creation and population of a Dimensional Database for a data warehousing solution. The goal is to design and implement a set of SQL-based operations and Python scripts to automate the process of transforming raw source data into a well-organized dimensional database that supports efficient querying and analysis.

### Key Objectives:

1. **Dimensional Database Creation**:
   - Create a new SQL Server database named `ORDER_DDS`.
   - Implement SQL scripts to create staging tables and dimensional tables with proper surrogate keys.
   
2. **Data Ingestion**:
   - Use parametrized SQL scripts to transfer data from staging tables into the corresponding dimension and fact tables.
   - Handle erroneous data by directing it into a dedicated error table.
   - Manage surrogate keys to maintain referential integrity between the staging and dimensional tables.
   
3. **Pipeline Automation**:
   - Develop Python scripts to automate the process of data ingestion.
   - Use the Python scripts to call SQL queries with dynamic parameters (e.g., start and end dates).
   - Ensure tasks are executed sequentially with error handling and dependencies between tasks.
   
4. **Logging and Monitoring**:
   - Set up a logger to track the execution of the data pipeline.
   - Include unique execution IDs to monitor each run of the pipeline.
   - Log outputs are stored in a file for tracking and troubleshooting purposes.

5. **Reproducibility and Efficiency**:
   - Focus on ensuring reproducibility, atomicity, and efficiency of the entire data pipeline.
   - Enable the pipeline to be easily re-run with different parameters while maintaining data integrity.

## Project Structure
```css
project/
│
├── infrastructure_initiation/
│   ├── dimensional_db_creation.sql
│   ├── dimensional_db_table_creation.sql
│   └── staging_raw_table_creation.sql
├── pipeline_dimensional_data/
│   ├── flow.py
│   ├── tasks.py
│   ├── queries/
│   ├──├── update_dim_categories.sql
│   ├──├── update_dim_customers.sql
│   ├──├── update_dim_employees.sql
│   ├──├── update_dim_products.sql
│   ├──├── update_dim_region.sql
│   ├──├── update_dim_shippers.sql
│   ├──├── update_dim_supplier.sql
│   ├──├── update_dim_territories.sql
│   ├──├── update_fact_error.sql
│   └──└──update_fact.sql
├── logs/
    └──  logs_dimensional_data_pipeline.txt
├── main.py
├── logging1.py
├── utils.py
├── requirements.txt
└── sql_server_config.cfg
```



### Project Structure:

- **`infrastructure_initiation/`**: Contains SQL scripts for database and table creation.
- **`pipeline_dimensional_data/`**: Contains Python scripts for orchestrating data ingestion tasks, and SQL queries for dimension and fact table updates.
- **`logs/`**: Logs the execution details of the dimensional data pipeline.
- **`main.py`**: Main entry point for running the pipeline.
- **`requirements.txt`**: Lists dependencies for the project.
- **`sql_server_config.cfg`**: Stores database connection configurations.
- **`logging1.py`**: Contains the configuration for logging the pipeline's execution, ensuring that logs include execution IDs for monitoring and troubleshooting.
- **`utils.py`**: Provides utility functions to aid in executing SQL scripts, handling database connections, and other repetitive tasks necessary for the data pipeline.

## How to Use

1. Set up your SQL Server connection by updating the `sql_server_config.cfg` file with your credentials.
2. Execute the necessary SQL scripts to create the database and tables in SQL Server.
3. Create a virtual environment using the command:
```
python -m venv C:\path\to\new\virtual\environment
```
4. Activate the virtual environment:

```
venv/Scripts/Activate.ps1
```
6. Download the requirements:
```
pip install -r requirements.txt
```
5. Run the `main.py` script to initiate the data pipeline with the desired parameters (start and end dates).
 Monitor the progress through the logs located in the `logs/` directory.

## Requirements

- Python 3.x
- SQL Server
- Required Python libraries: See `requirements.txt`
