select event , non_exa_event, operation ,count(*)
 from
 (select event,
          decode(event, 'cell smart table scan','',
  'cell smart index scan','',
  'cell statistics gather','',
  'cell smart incremental backup','',
  'cell smart file creation','',
  'cell smart restore from backup','',
  'cell single block physical read','db file sequential read',
  'cell multiblock physical read','db file scattered read',
  'cell list of blocks physical read','db file parallel read',
  'cell manager opening cell','',
  'cell manager closing cell','',
  'cell manager discovering disks','',
  'cell worker idle','',
  'cell smart flash unkeep','',
  'cell worker online completion','',
  'cell worker retry','',
  'cell manager cancel work request','') non_Exa_event,
  sql_plan_operation||' '||sql_plan_options operation
  from dba_hist_active_sess_history
  where event like 'cell%')
  where operation <> ' '
  order by 1
;
