#!/bin/bash

prefix='datalabframework environment: '

# check if docker and docker-compose are installed
if ! which docker > /dev/null
then
  echo $prefix docker executable not found
  exit 1
fi

if ! which docker-compose > /dev/null
then
  echo $prefix docker-compose executable not found
  exit 1
fi

# first argument is empty, or incorrect # of arguments hint for help
if [ $# -eq 0 ] || [ "$3" ]; then
  echo $prefix "type '$0 -h' for help"
  exit 1
fi

ROOTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# first argument is -h or empty, display help
case $1 in
  -h)
    echo $prefix Help:
    echo "   "  "'$0 -h' for help"
    echo "   "  "'$0 [--up|--down|--list] <compose-group>' brings up/down/list compose groups"
    retval=0
    ;;
  --list)
    echo $prefix
    echo compose groups:
    for fn in $(find  $ROOTPATH/compose -name docker-compose.yml); do
      pathname=$(dirname $fn)
      prefix=$ROOTPATH/compose/
      groupname=${pathname#$prefix}
      echo "   " - $groupname
    done
    retval=0
    ;;
  --up)
    composefile=$ROOTPATH/compose/$2/docker-compose.yml
    if [ -e $composefile ]
    then
      docker-compose -f $composefile up -d
      retval=0
    else
      echo $prefix compose group \'$2\' not found
      retval=1
    fi
    ;;
  --down)
    composefile=$ROOTPATH/compose/$2/docker-compose.yml
    if [ -e $composefile ]
    then
      docker-compose -f $composefile down
      retval=0
    else
      echo $prefix compose group \'$2\' not found
      retval=1
    fi
    ;;
  *)
    echo $prefix "wrong argument $1"
    echo $prefix "type '$0 -h' for help"
    retval=1
    ;;
esac

exit $retval