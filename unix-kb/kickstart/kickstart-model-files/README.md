Virtualbox when we create a vm, creates two kickstart files in root folder:  
If you want to install without graphical UI later on (like with Packer), comment out 'graphical' line in them and use.  
PW in vbox ks files is for root

-rw-------. 1 root root 1605 Sep  5 18:11 anaconda-ks.cfg  
-rw-r--r--. 1 root root 1636 Sep  5 18:18 initial-setup-ks.cfg   
