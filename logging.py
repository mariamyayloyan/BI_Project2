import logging
from logging.handlers import RotatingFileHandler
import uuid
import os

if not os.path.exists('logs'):
    os.makedirs('logs')

# Create logger for relational data flow
logger_rel = logging.getLogger('RelationalDataFlowLogger')
logger_rel.setLevel(logging.INFO)

handler_rel = RotatingFileHandler('logs/logs_relational_data_pipeline.txt', maxBytes=10000, backupCount=5)
handler_rel.setLevel(logging.INFO)

formatter_rel = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s - execution_id=%(execution_id)s')
handler_rel.setFormatter(formatter_rel)

logger_rel.addHandler(handler_rel)

def log_message_rel(level, msg):
    extra = {'execution_id': str(uuid.uuid4())}
    if level.lower() == 'info':
        logger_rel.info(msg, extra=extra)
    elif level.lower() == 'error':
        logger_rel.error(msg, extra=extra)
    elif level.lower() == 'warning':
        logger_rel.warning(msg, extra=extra)
    elif level.lower() == 'debug':
        logger_rel.debug(msg, extra=extra)


# Create logger for dimensional data flow
logger_dim = logging.getLogger('DimensionalDataFlowLogger')
logger_dim.setLevel(logging.INFO)

handler_dim = RotatingFileHandler('logs/logs_dimensional_data_pipeline.txt', maxBytes=10000, backupCount=5)
handler_dim.setLevel(logging.INFO)

formatter_dim = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s - execution_id=%(execution_id)s')
handler_dim.setFormatter(formatter_dim)

logger_dim.addHandler(handler_dim)

def log_message_dim(level, msg, execution_id):
    extra = {'execution_id': execution_id}
    if level.lower() == 'info':
        logger_dim.info(msg, extra=extra)
    elif level.lower() == 'error':
        logger_dim.error(msg, extra=extra)
    elif level.lower() == 'warning':
        logger_dim.warning(msg, extra=extra)
    elif level.lower() == 'debug':
        logger_dim.debug(msg, extra=extra)
