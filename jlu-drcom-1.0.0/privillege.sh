#!/bin/sh
getDir()
{
        dir=`echo $0 | grep "^/"`
        if test "${dir}"; then
                dirname "$0"
        else
                dirname "`pwd`/$0"
        fi

}
DIR=`getDir`
PATH="$DIR/change.sh"
#/bin/su - root -c "/bin/sh "$PATH" $DIR"
/bin/su - root -c "/bin/sh \"${PATH}\" \"${DIR}\""
exit
