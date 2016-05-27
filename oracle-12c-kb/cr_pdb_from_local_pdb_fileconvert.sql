--
--
--

CREATE PLUGGABLE DATABASE pdb2 FROM pdb1 
  PATH_PREFIX = '/disk2/oracle/pdb2'
  FILE_NAME_CONVERT = ('/disk1/oracle/pdb1/', '/disk2/oracle/pdb2/')
  NOLOGGING;
