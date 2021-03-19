#!/bin/sh

source ./config_params.sh

if [ ! -z "TIMESTAMP_AUTHORITY" ]; then
	TIMESTAMP_PARAMS="-tsa $TIMESTAMP_AUTHORITY" 
fi

if [ ! -z "$PROXY_HOST" ]; then
	PROXY_HOST_PARAMS="-J-Dhttp.proxyHost=$PROXY_HOST -J-Dhttps.proxyHost=$PROXY_HOST"
fi

if [ ! -z "$PROXY_PORT" ]; then
	PROXY_PORT_PARAMS="-J-Dhttp.proxyPort=$PROXY_PORT -J-Dhttps.proxyPort=$PROXY_PORT"
fi

# parameter 1 - the name of the unsigned jar (input)
# parameter 2 - the name of the signed jar (output)

input_jar=$1
output_jar=$2

if [ -z "$REDIRECT" ] ; then
	REDIRECT=/tmp/out #/dev/null
fi

# according to https://docs.oracle.com/javase/7/docs/technotes/guides/jar/jar.html#SignedJar-Overview
# there are some files for signed jars
# we will remove those from the jar archive

zip -d $input_jar 'META-INF/*.SF' 'META-INF/*.DSA' 'META-INF/*.RSA' 'META-INF/SIG-*' > $REDIRECT 2>&1
# we don't care about the result in case such files do not exist


jarsigner -verbose $TIMESTAMP_PARAMS $PROXY_HOST_PARAMS $PROXY_PORT_PARAMS -keystore $KEYSTORE -storepass $KEYSTORE_PASSWORD -keypass $KEY_PASS -signedjar $output_jar $input_jar $KEYSTORE_ALIAS >> $REDIRECT 2>&1
