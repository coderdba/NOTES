# method 1
python -c 'import crypt; print(crypt.crypt("CHANGEME", "$6$My Salt"))'

# method 2
echo 'import crypt,getpass; print crypt.crypt(getpass.getpass(), "$5$16_CHARACTER_SALT_HERE")' | python

# method 3 - this will prompt for a pw
grub-crypt --sha-256

# method 4 - this will prompt for a pw
grub-crypt --md5

# method 5 - this will prompt for a pw
openssl passwd -1 "password here"
