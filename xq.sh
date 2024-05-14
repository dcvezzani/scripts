function xq() {
local filename=$(cat < /dev/stdin)
# filename="$1"
local query="$1"

if [[ -z $filename ]] || [[ -z $query ]]; then
cat << EOL
Usage: ls <filename> | xq <query>
E.g.,: ls /Users/dcvezzani/projects/recovery-cms/src/main/xquery/_configuration/PROD/ldse-settings.xml | xq '//port'
EOL
return
fi

local CMD=$(cat << EOL
xidel --silent --xml --html "$filename" --xquery "$query" | grep -vE '<\/?body>|<\!DOCTYPE'
EOL
)

eval "$CMD"
}

cat << EOL
xq() has been loaded into the environment

$(ls ~/scripts/xq.xml | xq)
EOL
