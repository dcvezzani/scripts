#!/bin/bash

content="$@"
# echo "$content"

ruby -e "require 'json'; puts (eval \"$content\").to_json" | jq .
