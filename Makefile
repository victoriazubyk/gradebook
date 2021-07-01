CERTIFICATE_FOLDER = certificates
CERTIFICATE_CRT_NAME = "$(CERTIFICATE_FOLDER)/server.crt"
CERTIFICATE_KEY_NAME = "$(CERTIFICATE_FOLDER)/server.key"
CERTIFICATE_GENERATION_PARAMETERS = "/C=US"


gen_ssl_certs:
	@rm -rf $(CERTIFICATE_FOLDER)
	@mkdir $(CERTIFICATE_FOLDER)

	@openssl req -new -x509 -days 356 -nodes -text -out $(CERTIFICATE_CRT_NAME) \
			-keyout $(CERTIFICATE_KEY_NAME) -subj $(CERTIFICATE_GENERATION_PARAMETERS) &> /dev/null
	@echo "Created new certificates"

init: gen_ssl_certs
