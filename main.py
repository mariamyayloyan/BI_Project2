from pipeline_dimensional_data.flow import DimensionalDataFlow

if __name__ == "__main__":
    dimensional_data_flow = DimensionalDataFlow()
    
    try:
        #start_date = "2024-01-01"
        #end_date = "2024-12-31"
        start_date = None
        end_date = None
        dimensional_data_flow.exec(start_date=start_date, end_date=end_date)
    finally:
        dimensional_data_flow.close_connection()