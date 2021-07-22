if [ "$1" == "" ]; then
  echo "Usage: setjava.sh 11.0"
  exit 1
fi

export JAVA_HOME=$(/usr/libexec/java_home -v"$1")
jenv local "$1"
