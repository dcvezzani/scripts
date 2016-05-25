#!/bin/bash

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if (( $# != 2 ))
then
  echo "Usage e.g.: /Users/davidvezzani/scripts/parse_class.sh (admin|frontend|posv2|posv3|posv4|catalog|hive) Jobs::GetVariantSku::JobBuffer"
  exit 1
fi

path=

case "$1" in
admin)
  path="/Users/davidvezzani/reliacode/crystal_commerce/core/$1"
  ;;
frontend)
  path="/Users/davidvezzani/reliacode/crystal_commerce/core/$1"
  ;;
posv2)
  path="/Users/davidvezzani/reliacode/crystal_commerce/core/pos-v2"
  ;;
posv3)
  path="/Users/davidvezzani/reliacode/crystal_commerce/core/pos-v3"
  ;;
posv4)
  path="/Users/davidvezzani/reliacode/crystal_commerce/posv4/pos-v4"
  ;;
catalog)
  path="/Users/davidvezzani/reliacode/crystal_commerce/hive-inventory"
  ;;
hive)
  path="/Users/davidvezzani/reliacode/crystal_commerce/hive"
  ;;
esac

rails_class_name=$2
cd $path

echo "generating json"
#RAILS_CLASS_NAME=Jobs::GetVariantSku::JobBuffer rails runner "load '/Users/davidvezzani/scripts/parse_class.rb'"
filename=$(RAILS_CLASS_NAME=$rails_class_name bin/rails runner "load '/Users/davidvezzani/scripts/parse_class.rb'" | sed 'x;G;1!h;s/\n//g;$!d')

echo "parsing json"
cat $filename | jq -r 'def anchor_name(tclass_name; tmethod_name): (tclass_name + "-" + tmethod_name) | ascii_downcase |  gsub("[\\W_]+"; "-"); def emph_tag(tag_value; visibility): ( if(visibility == "public") then tag_value else " <i>" + tag_value + " [" + visibility[0:3] + "]</i> " end );  to_entries |  (first | .key) as $top_class_name | "" ,  ( map  ( .value.source_location as $source_location | .value.type as $class_type | .value.source_location as $source_location |  .value.queue as $queue | "" , .value.full_class_name as $full_class_name | ""  , .key as $class_name |   ( ("## (" +  ($class_type | .[0:1]) +  ") " +  $class_name +  "\n" ) ,  ("" + $source_location + "\n")  ) , ( .value.initializer_method as $init_meth | (if ($init_meth | length == 0)  then "" else  "### initializer_method\n" ,  ( (  .value.initializer_method as $init_meth |  ( $init_meth | to_entries |  ( map (  anchor_name($full_class_name; .key) as $anchor_name | if( (anchor_name(.value.class_name; .key)) == $anchor_name )  then (  ("* <a name=\"" + $anchor_name + "\"/>" + .key) , ("\n")  ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + .key) ,  ( " <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n" )  )  end ) | join("") ) ) ) )   end ) )  , ( (if((.value.instance_methods + .value.instance_methods_pro + .value.instance_methods_pri + .value.iinstance_methods) | length == 0) then ""  else  "### instance_methods\n" , ( ( .value.instance_methods |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | emph_tag(.key; .value.visibility) as $method_name |  if( (anchor_name(.value.class_name; .key)) == $anchor_name ) then ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , ("\n") ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , (" <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n") ) end ) | join("") ) ) ),  ( ( .value.instance_methods_pro |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | emph_tag(.key; .value.visibility) as $method_name |  if( (anchor_name(.value.class_name; .key)) == $anchor_name ) then ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , ("\n") ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , (" <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n") ) end ) | join("") ) ) ),  ( ( .value.instance_methods_pri |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | emph_tag(.key; .value.visibility) as $method_name |  if( (anchor_name(.value.class_name; .key)) == $anchor_name ) then ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , ("\n") ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , (" <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n") ) end ) | join("") ) ) ),  ("\n"), ( ( .value.iinstance_methods |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | emph_tag(.key; .value.visibility) as $method_name |  if( (anchor_name(.value.class_name; .key)) == $anchor_name ) then ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , ("\n") ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , (" <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n") ) end  ) | join("") ) ) ),  ( ( .value.iinstance_methods_pro |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | emph_tag(.key; .value.visibility) as $method_name |  if( (anchor_name(.value.class_name; .key)) == $anchor_name ) then ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , ("\n") ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , (" <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n") ) end  ) | join("") ) ) ),  ( ( .value.iinstance_methods_pri |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | emph_tag(.key; .value.visibility) as $method_name |  if( (anchor_name(.value.class_name; .key)) == $anchor_name ) then ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , ("\n") ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , (" <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n") ) end  ) | join("") ) ) ) end) ) , ( (if(.value.singleton_methods | length == 0) then ""  else  "### singleton_methods\n" , ( ( .value.singleton_methods |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | if( (anchor_name(.value.class_name; .key)) == $anchor_name ) then ( ("* <a name=\"" + $anchor_name + "\"/>" + .key) , ("\n") ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + .key) , (" <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n") ) end  ) | join("") ) ) ), ( ( .value.singleton_methods_pro |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | emph_tag(.key; .value.visibility) as $method_name |  if( (anchor_name(.value.class_name; .key)) == $anchor_name ) then ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , ("\n") ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , (" <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n") ) end ) | join("") ) ) ),  ( ( .value.singleton_methods_pri |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | emph_tag(.key; .value.visibility) as $method_name |  if( (anchor_name(.value.class_name; .key)) == $anchor_name ) then ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , ("\n") ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , (" <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n") ) end ) | join("") ) ) ),  ("\n"), ( ( .value.isingleton_methods |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | if( (anchor_name(.value.class_name; .key)) == $anchor_name ) then ( ("* <a name=\"" + $anchor_name + "\"/>" + .key) , ("\n") ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + .key) , (" <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n") ) end  ) | join("") ) ) ), ( ( .value.isingleton_methods_pro |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | emph_tag(.key; .value.visibility) as $method_name |  if( (anchor_name(.value.class_name; .key)) == $anchor_name ) then ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , ("\n") ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , (" <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n") ) end  ) | join("") ) ) ),  ( ( .value.isingleton_methods_pri |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | emph_tag(.key; .value.visibility) as $method_name |  if( (anchor_name(.value.class_name; .key)) == $anchor_name ) then ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , ("\n") ) else ( ("* <a name=\"" + $anchor_name + "\"/>" + $method_name) , (" <a href=\"#" + anchor_name(.value.class_name; .key) + "\">" + .value.class_name + "</a>" + "\n") ) end  ) | join("") ) ) ) end) ) , ( (if(.value.constants | length == 0) then ""  else  "### constants\n" , ( ( .value.constants |  to_entries | sort_by(.key) |  ( map ( anchor_name($full_class_name; .key) as $anchor_name | if( (.value.inspection | length) == 0 ) then ("* <a name=\"" + $anchor_name + "\"/>") , (" <a href=\"#" + $anchor_name + "\">" + .key + "</a>" + "\n") , (" : " + .value.type + "\n") else ("* <a name=\"" + $anchor_name + "\"/>" + .key) , (" : " + .value.type + " (e.g., " + .value.inspection + ")\n") end ) | join("") ) ) ) end) ) ) |  join("\n") )' > $filename.md

echo "DONE! Opening md..."
mvim $filename.md
