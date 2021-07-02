CERTIFICATE_FOLDER = "postgresql/certificates"
CERTIFICATE_CRT_NAME = "$(CERTIFICATE_FOLDER)/server.crt"
CERTIFICATE_KEY_NAME = "$(CERTIFICATE_FOLDER)/server.key"
CERTIFICATE_INFO_PARAMETERS = "/C=US"
DC = docker-compose

.PHONY: gen_ssl_certs
gen_ssl_certs:
	@rm -rf $(CERTIFICATE_FOLDER)
	@mkdir $(CERTIFICATE_FOLDER)

	@openssl req -new -x509 -days 356 -nodes -text -out $(CERTIFICATE_CRT_NAME) \
			-keyout $(CERTIFICATE_KEY_NAME) -subj $(CERTIFICATE_INFO_PARAMETERS) &> /dev/null
	@echo "New certificates created"

.PHONY: init
init: gen_ssl_certs

.PHONY: up
up:
	$(DC) -d up
