#!/bin/zsh

case "$1" in
admin)
  open http://localhost:3000
  ;;
frontend)
  open http://localhost:3000
  ;;
pos)
  open http://localhost:3000
  ;;
roadhouse|RoadHouse)
  open http://localhost:3014
  ;;
catalog|hive-inventory)
  open http://localhost:3000
  ;;
sinewave)
  open http://localhost:3016
  ;;
support)
  open http://localhost:3000
  ;;
*)
  open http://localhost:3000
  ;;
esac

