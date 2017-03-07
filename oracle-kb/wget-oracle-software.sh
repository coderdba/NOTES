#!/bin/sh

#
# Generated 3/6/17 10:44 AM
# Start of user configurable variables
#
LANG=C
export LANG

# SSO username and password
SSO_USERNAME=<your orcale otn or support username>
SSO_PASSWORD=<password>



# Path to wget command
WGET=/usr/bin/wget

# Location of cookie file
COOKIE_FILE=/tmp/$$.cookies

# Log directory and file
LOGDIR=.
LOGFILE=$LOGDIR/wgetlog-`date +%m-%d-%y-%H:%M`.log

# Output directory and file
OUTPUT_DIR=.

#
# End of user configurable variable
#

if [ "$SSO_PASSWORD " = " " ]
then
 echo "Please edit script and set SSO_PASSWORD"
 exit
fi

# Contact updates site so that we can get SSO Params for logging in
SSO_RESPONSE=`$WGET --user-agent="Mozilla/5.0" https://updates.oracle.com/Orion/Services/download 2>&1|grep Location`

# Extract request parameters for SSO
SSO_TOKEN=`echo $SSO_RESPONSE| cut -d '=' -f 2|cut -d ' ' -f 1`
SSO_SERVER=`echo $SSO_RESPONSE| cut -d ' ' -f 2|cut -d 'p' -f 1,2`
SSO_AUTH_URL=sso/auth
AUTH_DATA="ssousername=$SSO_USERNAME&password=$SSO_PASSWORD&site2pstoretoken=$SSO_TOKEN"

# The following command to authenticate uses HTTPS. This will work only if the wget in the environment
# where this script will be executed was compiled with OpenSSL. Remove the --secure-protocol option
# if wget was not compiled with OpenSSL
# Depending on the preference, the other options are --secure-protocol= auto|SSLv2|SSLv3|TLSv1
$WGET --user-agent="Mozilla/5.0" --secure-protocol=auto --post-data $AUTH_DATA --save-cookies=$COOKIE_FILE --keep-session-cookies $SSO_SERVER$SS                        O_AUTH_URL -O sso.out >> $LOGFILE 2>&1

rm -f sso.out

$WGET  --user-agent="Mozilla/5.0"  --load-cookies=$COOKIE_FILE --save-cookies=$COOKIE_FILE --keep-session-cookies "https://updates.oracle.com/Or                        ion/Services/download/p20485724_121020_Linux-x86-64.zip?aru=18582440&patch_file=p20485724_121020_Linux-x86-64.zip" -O $OUTPUT_DIR/p20485724_1210                        20_Linux-x86-64.zip   >> $LOGFILE 2>&1


# Cleanup
rm -f $COOKIE_FILE
