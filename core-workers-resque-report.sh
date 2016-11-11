#!/bin/bash

host_prefix="core-worker"
dts=$(date +%Y%m%s%H%M%S)
filename="${host_prefix}s-report-${dts}"

line_count=10000

echo "" > $filename.txt
for idx in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25; do
  echo "# === $host_prefix$idx ==================" >> $filename.txt
  ssh $host_prefix$idx "cat core/current/admin/config/resque-pool.yml" >> $filename.txt
  echo -e "\n\n" >> $filename.txt
done

echo "mvim $filename.txt"

