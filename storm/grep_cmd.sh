#!/bin/bash

ssh devstorm 'grep -e " ls" -e "Light" -e "light" -e "LIGHT" -e "comet" -e "Comet" -e "COMET" "'$1'"'
