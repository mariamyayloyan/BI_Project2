import logging
from logging.handlers import RotatingFileHandler
import uuid
import os


# Create logger for dimensional data flow
logger_dim = logging.getLogger('DimensionalDataFlowLogger')
logger_dim.setLevel(logging.INFO)

def log_message_dim(level, msg, execution_id=None):
    if execution_id is None:
        execution_id = str(uuid.uuid4())  
    extra = {'execution_id': execution_id} 

     

    formatter_dim = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s - execution_id=%(execution_id)s')
    handler_dim.setFormatter(formatter_dim)


    logger_dim.addHandler(handler_dim)

    
    if level.lower() == 'info':
        logger_dim.info(msg, extra=extra)
    elif level.lower() == 'error':
        logger_dim.error(msg, extra=extra)
    elif level.lower() == 'warning':
        logger_dim.warning(msg, extra=extra)
    elif level.lower() == 'debug':
        logger_dim.debug(msg, extra=extra)




handler_dim = RotatingFileHandler('logs/logs_dimensional_data_pipeline.txt', maxBytes=10000, backupCount=5)
handler_dim.setLevel(logging.INFO)

