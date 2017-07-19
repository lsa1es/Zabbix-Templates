#!/bin/sh
# Luiz Sales
# luiz@lsales.biz
#
# Certificate SSL expired 

SERVER=$2
PORT=$3
if [ -z "$3" ]
then
	PORT=443;
	else
	PORT=$3;
fi

lld() {
	echo "{\"data\":["
	for x in `echo $SERVER | sed 's/,/ /g'`
	do
		echo "{\"{#WEBSSL}\":\"$x\"},"
	done
	echo "]}"
}

get() { 
	TIMEOUT=25
	RETVAL=0
	TIMESTAMP=`echo | date`
	EXPIRE_DATE=`echo | openssl s_client -connect $SERVER:$PORT 2>/dev/null | openssl x509 -noout -dates 2>/dev/null | grep notAfter | cut -d'=' -f2`
	EXPIRE_SECS=`date -d "${EXPIRE_DATE}" +%s`
	EXPIRE_TIME=$(( ${EXPIRE_SECS} - `date +%s` ))
	if test $EXPIRE_TIME -lt 0
	then
		RETVAL=0
	else
		RETVAL=$(( ${EXPIRE_TIME} / 24 / 3600 ))
	fi

	echo ${RETVAL} 

}

help() {
	echo "lld - get"
}

case $1 in 
	lld) lld  | sed ':a;$!{N;ba;};s/\(.*\)},/\1}/'
	;;
	get) get
	;;
	*) help
	;;
esac

