-- on source db

SELECT force_logging FROM v$database;

-- Enable forced logging.
ALTER DATABASE FORCE LOGGING;

-- Verify that forced logging is enabled.
SELECT force_logging FROM v$database;

-- Switch the log files.
ALTER SYSTEM SWITCH LOGFILE;
