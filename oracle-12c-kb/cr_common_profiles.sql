--
--
-- To create common profiles
--
--

create profile c##common_profile limit 
failed_login_attempts unlimited
password_verify_function ora12c_verify_function;

CREATE PROFILE c##app_users LIMIT 
   SESSIONS_PER_USER          UNLIMITED 
   CPU_PER_SESSION            UNLIMITED 
   CPU_PER_CALL               3000 
   CONNECT_TIME               45 
   LOGICAL_READS_PER_SESSION  DEFAULT 
   LOGICAL_READS_PER_CALL     1000 
   PRIVATE_SGA                15K
   COMPOSITE_LIMIT            5000000; 
