#!/bin/bash

# Script to create a genesis file PoW
# jq is required : npm install jq-cli-wrapper
# Example of use :
# ./generate_genesis_pow.sh network_name 22 0x6265000000000000000000000000000000000000000000000000000000000000

echo "=========Arguments supplied=============="
echo "Network name (name of file): $1"
echo "Network Id: $2"
echo "Data to put in genesis file as hex: $3"
echo "========================================="
# Account to prefund are hardcoded (0000000000000000000000000000000000000000 to 0000000000000000000000000000000000000010)

#Check name is not empty
if [ -z "$1" ]; 
then
  echo "ERROR: Please enter a network name. Exiting..."
  exit 1
fi

# Check that name doesn't exist already
if [ -f ./$1_pow.json ]
then
  echo "ERROR: File with this network name already exist. Exiting..."
  exit 1
fi

# Check network id is an int
re='^[0-9]+$'
if ! [[ "$2" =~ $re ]] ; then
   echo "ERROR: Network id is not a number. Exiting..."
   exit 1
fi

# check data is an hex if not empty
if [ ! -z "$3" ]; 
then
	if [ "${#3}" != 66 ] ; then
	   echo "ERROR: Extra data is not 66 chars. Exiting..."
	   exit 1
	fi
	hex='0[xX][0-9a-fA-F]+'
	if ! [[ "$3" =~ $hex ]] ; then
	   echo "ERROR: Extra data is not hex. Exiting..."
	   exit 1
	fi
fi

# Copy sample file to our file
cp sample_genesis_POW.json $1_pow.json
# NETWORK ID
jq --arg NETWORKID $2 '.config.chainId = ($NETWORKID|tonumber)' $1_pow.json > $1_pow.$$.json  && mv $1_pow.$$.json $1_pow.json

# Data to put in genesis file
if [ ! -z "$3" ]; 
then
	jq --arg EXTRADATA $3 '.extraData = $EXTRADATA' $1_pow.json > $1_pow.$$.json && mv $1_pow.$$.json $1_pow.json
fi

echo "POW Genesis file $1_pow.json sucessfully created."