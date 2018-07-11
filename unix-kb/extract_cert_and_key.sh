if [ $# -lt 1 ]
then
echo
echo "Usage: $0  certificate_file_with_passworded_key (as filename.pem )"
echo
echo Example: $0 myserver.pem
echo
exit
fi

certfile_with_key_and_pw=$1
filebase=`basename $certfile_with_key_and_pw .pem`

cert_file=${filebase}.cer
key_file=${filebase}.pem

key_file_withpw=${filebase}.pem.withpw
key_file_withnopw=${filebase}.pem.nopw

/bin/rm -f $key_file_withpw
/bin/rm -f $key_file_withnopw

downloaded_renamed_file=${certfile_with_key_and_pw}.downloaded.cert_key_and_pw

/bin/mv -f $certfile_with_key_and_pw $downloaded_renamed_file

sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' $downloaded_renamed_file > $cert_file

sed -n '/-----BEGIN RSA PRIVATE KEY-----/,/-----END RSA PRIVATE KEY-----/p' $downloaded_renamed_file > $key_file_withpw

openssl rsa -in $key_file_withpw -out $key_file_withnopw

if [ $? -ne 0 ]
then
     echo
     echo "ERR - Error in removing password from key. Rerun with correct password"
     echo
     exit
fi

/bin/mv -f $key_file_withnopw $key_file
/bin/rm $key_file_withpw

echo
echo IF NO ERROR SO FAR
echo
echo then, use the following files: 
echo       $cert_file  
echo       $key_file
echo
