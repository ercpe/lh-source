#!/sbin/runscript

SCRIPT="/usr/sbin/firewall.sh";

depend() {
	need net
	use dns logger
}


start() {
	einfo "Starting firewall";

	if [[ ! -d "$CONFIG_DIR" || ! -d "${CONFIG_DIR}/started" ]]; then
		eerror "CONFIG_DIR not set";
	else
		${SCRIPT} "${CONFIG_DIR}/started";
	fi
}

stop() {
	einfo "Stopping firewall";

	if [[ ! -d "$CONFIG_DIR" || ! -d "${CONFIG_DIR}/stopped" ]]; then
		eerror "CONFIG_DIR not set";
	else
		${SCRIPT} "${CONFIG_DIR}/stopped";
	fi
}

status() {
	iptables -L -x
}
