#!/bin/bash
ROOT="/etc/admin/ovpn/data-develop6"
NET="10.99.99.0/24"
PORT="1192"
HOST="jeshkov.ru"

if [ ! -d $ROOT ]; then
	mkdir $ROOT
fi

rm -rf ${ROOT}/*
docker run --rm -v ${ROOT}:/etc/openvpn localhost/ovpnweb6 ovpn_genconfig -u udp://${HOST}:${PORT} -d -s ${NET} -r ${NET} -e 'topology subnet' -6 'fd7d:6fbd:828c:022c::/64' -e 'ccd-exclusive' -e 'crl-verify crl.pem' -e 'management localhost 7505'
docker run --rm -v ${ROOT}:/etc/openvpn -it localhost/ovpnweb6 ovpn_initpki nopass
docker run --rm -it -v ${ROOT}:/etc/openvpn localhost/ovpnweb6 easyrsa gen-crl

#echo 'declare -x OVPN_CUSTOM_CLIENT_OPTIONS="management localhost 7505"' >> ${ROOT}/ovpn_env.sh

