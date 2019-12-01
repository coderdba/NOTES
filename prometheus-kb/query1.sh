#!/bin/bash
set -e -o pipefail
date
free -b
curl -s 'http://localhost:9100/metrics?collect\[\]=meminfo' |
  egrep '^node_memory_Mem(Total|Free|Available)_bytes'
egrep 'Mem(Total|Free|Available):' /proc/meminfo |
  awk '{print $1 $2 * 1024}'
free -b
date
