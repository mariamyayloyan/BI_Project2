from pipeline_relational_data.flow import RelationalDataFlow
from pipeline_dimensional_data.flow import DimensionalDataFlow


if __name__ == "__main__":
    relational_data_flow = RelationalDataFlow()
    
    try:
        relational_data_flow.exec()
    finally:
        relational_data_flow.close_connection()
    
    dimensional_data_flow = DimensionalDataFlow()
    
    try:
        dimensional_data_flow.exec()
    finally:
        dimensional_data_flow.close_connection()