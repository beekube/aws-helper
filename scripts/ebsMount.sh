#!/bin/bash

# Get a valid device name
str=$(lsblk -d -J | jq -r -c '.blockdevices | map(.name) | .[-1]' )
next=$(echo "${str: -1}" | tr '[a-y]z' '[b-z]a')
deviceId="/dev/xvd$next"

ebs=$1 #"vol-0342621a9c6047908"

# Attach the volume
aws ec2 attach-volume --device $deviceId --volume-id $ebs --instance-id $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)

echo "$deviceId"

sleep 2

localmount="volumes/$2/$3"
mkdir -p $localmount
mount $deviceId $localmount