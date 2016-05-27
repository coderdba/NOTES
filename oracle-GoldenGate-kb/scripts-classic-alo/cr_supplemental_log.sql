ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
SELECT supplemental_log_data_min, force_logging FROM v$database;
