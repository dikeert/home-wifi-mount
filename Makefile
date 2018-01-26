
NAME = 99-home-wifi.sh
DISPATCHER = "/etc/NetworkManager/dispatcher.d"

install: preup predown
	@cp ./${NAME} ${DISPATCHER}/${NAME} && \
		chmod +x ${DISPATCHER}/${NAME}

predown:
	@cp ./${NAME} ${DISPATCHER}/pre-down.d/${NAME} && \
		chmod +x ${DISPATCHER}/pre-down.d/${NAME}

preup:
	@cp ./${NAME} ${DISPATCHER}/pre-up.d/${NAME} && \
		chmod +x ${DISPATCHER}/pre-up.d/${NAME}
