-- https://kendralittle.com/2016/10/17/decoding-key-and-page-waitresource-for-deadlocks-and-blocking/

Find the blocker tree from the blockers-and-waiters1.sql
If the blocker is at a page level, you get something like "PAGE: 8:5:3555002" in the wait_resource.
To find out which table/index/data is that page - look up the website above

head_blocker_session_id	session_id	blocking_session_id	wait_type	wait_duration_ms	wait_resource
480	480	0	SLEEP_TASK	1	
480	490	480	LCK_M_U	8285	PAGE: 8:5:3555002 
