create spfile from pfile='/tmp/pfile.ora';

-- restart to make required control-file locations to take effect 
-- (otherwise controlfile gets restored to dbs folder)
shutdown;
startup nomount;
