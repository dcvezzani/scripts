#!/bin/bash

# ====================================================
# parse knex sql

function parseKnexSql() {

local sql="$1"

if [[ -z $sql ]]; then
  cat << EOL
Usage: ~/scripts/parse-knex-sql-json/parse-knex-sql-json.sh <sql>
EOL
exit 1
fi

local CMD=$(cat << EOL
echo '$sql' | ~/scripts/parse-knex-sql-json/parse-knex-sql-json.js \\
| prettier --plugin=prettier-plugin-sql --stdin-filepath /tmp/prettier-stdin-filepath.sql
EOL
)

if [[ $DEBUG == 'true' ]]; then
eval "$CMD"
else
eval "$CMD" 2> /dev/null
fi

}

# ====================================================
# parse sql

function parseSql() {

local sql="$1"

if [[ -z $sql ]]; then
  cat << EOL
Usage: ~/scripts/parse-knex-sql-json/parse-knex-sql-json.sh <sql>
EOL
exit 1
fi

local CMD=$(cat << EOL
echo '$sql' | prettier --plugin=prettier-plugin-sql --stdin-filepath /tmp/prettier-stdin-filepath.sql
EOL
)

if [[ $DEBUG == 'true' ]]; then
echo "$CMD"
else
eval "$CMD" 2> /dev/null
fi

}

function parseSqlPipe() {
children=$(cat < /dev/stdin)
echo $children | prettier --plugin=prettier-plugin-sql --stdin-filepath /tmp/prettier-stdin-filepath.sql
}



# ====================================================
# run entry point
#

if [[ -p /dev/stdin ]] ; then 
  echo "not a terminal" 1>&2

children=$(cat < /dev/stdin)
echo $children 1>&2
echo $children | prettier --plugin=prettier-plugin-sql --stdin-filepath /tmp/prettier-stdin-filepath.sql | perl -p -e 's/__astrisk__/*/g'
  
else 
  echo terminal

  chk=$(echo "$1" | perl -n -e 'print if /^\{/' | wc -l | xargs)
  if [[ $chk > 0 ]]; then
    echo "Parsing knex sql..." 1>&2
    parseKnexSql "$1"
  else
    echo "Parsing plain sql..." 1>&2
    parseSql "$1"
  fi

fi



# ====================================================
# archive/comments

COMMENT=$(cat << 'EOL'

echo 'select * from meetings' | prettier --plugin=prettier-plugin-sql --stdin-filepath /tmp/prettier-stdin-filepath.sql

~/scripts/parse-knex-sql-json/parse-knex-sql-json.sh '{ "method": "select", "bindings": [ 100 ], "sql": "select \"meetings\".\"id\" from \"meetings\" where \"meetings\".\"id\" = ?" }'

~/scripts/parse-knex-sql-json/parse-knex-sql-json.sh 'select * from meetings'

DEBUG=true ~/scripts/parse-knex-sql-json/parse-knex-sql-json.sh '{ "method": "select", "options": {}, "timeout": false, "cancelOnTimeout": false, "bindings": [ "menAndWomen", "menOnly", "womenOnly", "ysaMenAndWomen", "ysaMenOnly", "ysaWomenOnly", "couples", "wives", "null" ], "__knexQueryUid": "W6rKxuLhlNZ_5KABdkRGA", "sql": "select \"meetings\".\"id\", \"meetings\".\"cmis_requesting_unit_id\", \"meetings\".\"fk_location_id\", \"meetings\".\"title\", \"meetings\".\"status\", \"meetings\".\"host_key\", \"meetings\".\"fk_topic_id\", \"meetings\".\"fk_audience_id\", \"meetings\".\"fk_group_id\", \"meetings\".\"language_code\", \"meetings\".\"fk_meeting_type_id\", \"meetings\".\"time_of_day\", \"meetings\".\"day_of_week\", \"meetings\".\"time_zone\", \"meetings\".\"primary_phone_number\", \"meetings\".\"primary_conference_code\", \"meetings\".\"secondary_phone_number\", \"meetings\".\"secondary_conference_code\", \"meetings\".\"special_instructions\", \"meetings\".\"is_private\", \"meetings\".\"fk_office_id\", \"meetings\".\"starts_at\", \"meetings\".\"created_at\", \"meetings\".\"created_by\", \"meetings\".\"updated_at\", \"meetings\".\"updated_by\", \"meetings\".\"archived_at\", \"meetings\".\"legacy_id\", \"meetings\".\"url\" from \"meetings\" left join \"labels\" as \"meeting_types\" on \"meetings\".\"fk_meeting_type_id\" = \"meeting_types\".\"id\" left join \"labels\" as \"audiences\" on \"meetings\".\"fk_audience_id\" = \"audiences\".\"id\" left join \"labels\" as \"topics\" on \"meetings\".\"fk_topic_id\" = \"topics\".\"id\" left join \"labels\" as \"group_types\" on \"meetings\".\"fk_group_id\" = \"group_types\".\"id\" where \"audiences\".\"key\" in (?, ?, ?, ?, ?, ?, ?, ?) and \"meeting_types\".\"key\" in (?)" }'
EOL
)
