#!/bin/zsh

case "$1" in
admin)
  open https://katelyntest-admin.crystalcommerce.com/
  ;;
frontend)
  open https://katelyntest.crystalcommerce.com/
  ;;
pos)
  open https://katelyntest-pos.crystalcommerce.com/
  ;;
roadhouse|RoadHouse)
  open https://developers.crystalcommerce.com/
  ;;
catalog|hive-inventory)
  open https://catalog.crystalcommerce.com/
  ;;
sinewave)
  open https://accounts.crystalcommerce.com/
  ;;
support)
  open http://internalsupport.crystalcommerce.com/
  ;;
*)
  open https://katelyntest-admin.crystalcommerce.com/
  ;;
esac

