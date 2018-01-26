#!/bin/bash

INTERFACE="wlp4s0"
HOME_SSID="p2t2p"

log() {
	local level="${1}"
	local msg="${2}"
	echo "${msg}" | systemd-cat -t "Home WiFi" -p "${level}"
}

info() {
	local msg="[${FUNCNAME[1]}]: $1"
	log info "${msg}" 
}

warn() {
	local msg="[${FUNCNAME[1]}]: $1"
	log warning "${msg}"
}

onConnected() {
	local ssid="${1}"
	if [ "${ssid}" == "${HOME_SSID}" ]; then
		info "Home sweet home"
		info "Mounting Time Capsule"
		systemctl start media-capsule.mount
	fi
}

onDisconnected() {
	local ssid="${1}"

	if [ "${ssid}" == "${HOME_SSID}" ]; then
		warn "Disconnected from home network"
		info "Unmounting Time Capsule"
		systemctl stop media-capsule.mount
	fi
}

run() {
	local iface="${1}"
	local event="${2}"
	local ssid=$(iwgetid -r)
	
	if [ "__x__${ssid}" == "__x__" ]; then
		info "No ssid available, reading recent ssid from file"
		ssid="$(cat /tmp/ssid)"
		info "Recent [ssid=${ssid}]"
	else
		info "Storing [ssid=${ssid}] info file"
		echo "${ssid}" > /tmp/ssid
	fi

	if [ "${iface}" == "${INTERFACE}" ]; then
		if [ "${event}" == "up" ]; then
			onConnected "${ssid}"
		fi

		if [ "${event}" == "down" ]; then
			onDisconnected "${ssid}"
		fi
	fi
}

run $@ 
