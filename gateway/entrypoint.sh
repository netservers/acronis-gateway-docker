#!/bin/bash
set -e -x
ACRONIS_PORT=${ACRONIS_PORT:-44445}
STORE_UID=$(stat -c %u /var/lib/Acronis/storage)
STORE_GID=$(stat -c %g /var/lib/Acronis/storage)
ACRONIS_UID=${ACRONIS_UID:-$STORE_UID}
ACRONIS_GID=${ACRONIS_GID:-$STORE_GID}
CURRENT_UID=`id -u acronis`
CURRENT_GID=`id -g acronis`

if [ "$ACRONIS_UID" != "$CURRENT_UID" ]; then
	usermod -u $ACRONIS_UID acronis
fi
if [ "$ACRONIS_GID" != "$CURRENT_GID" ]; then
	groupmod -g $ACRONIS_UID acronis
fi

if [ "$ACRONIS_UID" != "$STORE_UID" ] || [ "$ACRONIS_GID" != "$STORE_GID" ]; then
	chown -R acronis:acronis /var/lib/Acronis/*
fi
chown -R acronis:acronis /etc/pki/tls/certs/Acronis/storage/ /var/log/Acronis/*

if [ ! -e "/etc/pki/tls/certs/Acronis/storage/fes.pem" ]; then
	if [ "$ACRONIS_HOSTNAME" == "" ]; then
	        MYIP=`curl ifconfig.co`
		ACRONIS_HOSTNAME=$MYIP
	fi
	acronis-storage-registration -u "$ACRONIS_USERNAME" -p "$ACRONIS_PASSWORD" -s cloud.acronis.com -a "$ACRONIS_HOSTNAME" -i "$ACRONIS_GATEWAYID" -o "/etc/pki/tls/certs/Acronis/storage/"
fi

xmlstarlet ed --inplace -u "//ArchivingStorageSystemConfiguration/FrontEndServer/InternetInterface" -v "0.0.0.0:${ACRONIS_PORT}" /etc/Acronis/acronis-storage-gateway.xml

unset ACRONIS_PASSWORD

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf