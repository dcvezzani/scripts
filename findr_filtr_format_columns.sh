#!/bin/bash

#args='"app/support/order_action/nested_stack.rb:4: extend ::OrderAction::Stack" "lib/channels/amazon_mws/lib/turbo_stores/amazon_mws/check_orders.rb:6: extend ::OrderAction::Stack" "lib/channels/amazon_mws/lib/turbo_stores/amazon_mws/order_action/process_order.rb:5: extend ::OrderAction::Stack" "lib/channels/tcg_player/lib/turbo_stores/tcg_player/order_action/create_order.rb:5: extend ::OrderAction::Stack" "lib/channels/tcg_player/lib/turbo_stores/tcg_player/order_action/get_shipping_options.rb:5: extend ::OrderAction::Stack" "lib/channels/tcg_player/lib/turbo_stores/tcg_player/order_action/send_tracking_number.rb:5: extend ::OrderAction::Stack"'

colw=70
divw=10
IFS=$'"' 

if [[ ! -n ${1//[0-9]/} ]]; then
   #echo "error: Not a number" >&2; exit 1
   colw=$1
   shift
fi
#echo ">>> colw: ${colw}"

if [[ ! -n ${1//[0-9]/} ]]; then
   #echo "error: Not a number" >&2; exit 1
   divw=$1
   shift
fi
#echo ">>> divw: ${divw}"

colwe=$(expr $colw - 3)

for line in $(echo "$@"); do
  line=$(echo "${line}" | sed -e 's/^[[:space:]]*//')

  if [ ${#line} -ne 0 ]; then
    line=$(echo "${line}" | sed -e 's/\(:[0-9]*:\)[[:space:]]*/\1 /g')

    left=$(echo ${line%%: *})
    right=$(echo ${line#*: } | sed -e 's/^[[:space:]]*//')

    if [ ${#left} -gt $colw ]; then
      left="...${left:$(expr ${#left} - $colwe):${#left}}"
    fi

    if [ ${#right} -gt $colw ]; then
      right="${right:0:$colwe}..."
    # else
    #   pad_len=$(expr $colw - ${#right})
    #   right=$(printf "%0s%${pad_len}s" "$right" ".")
    fi

    printf "%${colw}s%${divw}s%0s\n" "$left" " " "$right"
  fi
done 
unset IFS


#for line in $@
#for line in $(echo $args | sed -e 's/^.//' | sed -e 's/.$//')
#do
#  echo "'${line}'"
#  left=$(echo ${line%: *})
#  right=$(echo ${line#*: } | sed -e 's/^[[:space:]]*//')
#
#  #echo "'"$left"'"
#  #echo "'"$right"'"
#
#  #printf '%50s' "$left"
#  #printf '%-50s' "$right"
#
#  # printf "%50s%10s%0s\n" "$left" " " "$right"
#done



# IFS="${IFS_OLD}"
# 
# array=( $(echo $args | sed -e 's/^.//' | sed -e 's/.$//' | grep -o '\"[^\"]*\"') )
# array=( $(echo $args | grep -o '\"[^\"]*\"') )
# 
# 
# args=$(echo "${*}")
# declare -a lines
# 
# while [ $#args -gt 0 ]; do
#   lines_len=${#lines[@]}
#   $lines[$lines_len]="${args%\"*}"
# done
# 
# for line in $@
# do
#   echo "'${line}'"
#   left=$(echo ${line%: *})
#   right=$(echo ${line#*: } | sed -e 's/^[[:space:]]*//')
# 
#   #echo "'"$left"'"
#   #echo "'"$right"'"
# 
#   #printf '%50s' "$left"
#   #printf '%-50s' "$right"
# 
#   # printf "%50s%10s%0s\n" "$left" " " "$right"
# done
