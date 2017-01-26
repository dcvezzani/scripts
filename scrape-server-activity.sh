#!/bin/bash

host_prefix="core-app"
prefix="$host_prefix-activity-report-$(date +%Y%m%s%H%M%S)"
line_count=10000

echo "" > $prefix.txt
for idx in 01 02 03 04 05 06 07 08 09 10; do
  echo "# === $host_prefix$idx ==================" >> $prefix.txt
  ssh $host_prefix$idx "tail -n $line_count core/current/admin/log/admin.log" >> $prefix.txt
  echo -e "\n\n" >> $prefix.txt
done

echo "mvim $prefix.txt"


# host_prefix="core-worker"
# prefix="$host_prefix-activity-report-$(date +%Y%m%s%H%M%S)"
# line_count=10000
#
# echo "" > $prefix.txt
# for idx in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15; do
#   echo "# === $host_prefix$idx ==================" >> $prefix.txt
#   ssh $host_prefix$idx "tail -n $line_count core/current/admin/log/admin.log" >> $prefix.txt
#   echo -e "\n\n" >> $prefix.txt
# done
#
# echo "mvim $prefix.txt"
#
#
# Hijacker.connect 'supergamesinc'
#
# AmazonMwsState.where(feed_submission_id: '102-2792453-3468202').count
#
# 102-2792453-3468202
#
# Hijacker.connect 'supergamesinc'
# AmazonMwsState.where(amazon_order_id: '102-2792453-3468202').count
# AmazonMwsState.where(feed_submission_id: '102-2792453-3468202').count
