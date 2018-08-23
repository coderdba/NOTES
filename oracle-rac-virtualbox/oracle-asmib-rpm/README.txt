ORACLEASM / ASMLIB INSTALL

INSTALL:
https://docs.oracle.com/en/database/oracle/oracle-database/18/ladbi/installing-and-configuring-oracle-asmlib-software.html#GUID-79F9D58F-E5BB-45BD-A664-260C0502D876

DEINSTALL:
https://docs.oracle.com/en/database/oracle/oracle-database/18/ladbi/deinstalling-oracle-asmlib-on-oracle-database.html#GUID-F7B288F6-A1A3-4E87-B6A5-4EBDDCE1773F

INSTALLATION INSTRUCTIONS:

According to 18c install guide:
# yum install -y oracleasm
# yum install -y oracleasm-support
# yum install oracleasmlib --> THIS ONE, DOWNLOADED FROM http://www.oracle.com/technetwork/server-storage/linux/asmlib/index-101839.html --> (for OEL7) http://www.oracle.com/technetwork/server-storage/linux/asmlib/ol7-2352094.html

According to 2day DBA +  RAC 11g document,
https://docs.oracle.com/cd/E11882_01/rac.112/e17264/preparing.htm#TDPRC145

The following RPMs are needed:
# rpm -Uvh oracleasm-support-2.1.3-1.el4.x86_64.rpm
# rpm -Uvh oracleasmlib-2.0.4-1.el4.x86_64.rpm
# rpm -Uvh oracleasm-2.6.9-55.0.12.ELsmp-2.0.3-1.x86_64.rpm

THE ASMLIB DOWNLOAD SITE:

http://www.oracle.com/technetwork/server-storage/linux/downloads/index.html
--> http://www.oracle.com/technetwork/server-storage/linux/asmlib/index-101839.html
-->--> http://www.oracle.com/technetwork/server-storage/linux/asmlib/ol7-2352094.html
-->-->--> http://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.12-1.el7.x86_64.rpm

Oracle ASMLib Downloads for Oracle Linux 7

Note: All ASMLib installations require the oracleasmlib and oracleasm-support packages appropriate for their machine.

The oracleasm-support package can be downloaded from the Unbreakable Linux Network (ULN) if you have an active support subscription, or from http://public-yum.oracle.com if you do not. 

The oracleasm kernel driver is built into the Unbreakable Enterprise Kernel for Oracle Linux 7 and does not need to be installed manually. 

The oracleasm kernel driver for the 64-bit (x86_64) Red Hat Compatible Kernel for Oracle Linux 7 can be installed manually from ULN or http://public-yum.oracle.com using the yum tool:
# yum install kmod-oracleasm

This kernel driver is not version-specific and does not need to be upgraded when the kernel is upgraded.

Also, see the release notes.
Jump to:

Intel EM64T (x86_64) Architecture
Oracle ASMLib 2.0
Intel EM64T (x86_64) Architecture
Library and Tools
oracleasmlib-2.0.12-1.el7.x86_64.rpm


