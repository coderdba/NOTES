dcli -g /root/vm_group -l root '/u01/app/12.2.0.1/grid/bin/olsnodes -n | grep 1$' > tmp1

cat tmp1 | awk '{print $2}' > tmp2
cat tmp2 |sort |uniq

/bin/rm tmp1 tmp2
