CERTIFICATE_FOLDER = "postgresql/certificates"
CERTIFICATE_CRT_NAME = "$(CERTIFICATE_FOLDER)/server.crt"
CERTIFICATE_KEY_NAME = "$(CERTIFICATE_FOLDER)/server.key"
CERTIFICATE_INFO_PARAMETERS = "/C=US"
SECRET_KEY_FILE = .envs/.secretkey.django.env
DC = docker-compose

.PHONY: gen_ssl_certs
gen_ssl_certs:
	@rm -rf $(CERTIFICATE_FOLDER)
	@mkdir $(CERTIFICATE_FOLDER)

	@openssl req -new -x509 -days 356 -nodes -text -out $(CERTIFICATE_CRT_NAME) \
			-keyout $(CERTIFICATE_KEY_NAME) -subj $(CERTIFICATE_INFO_PARAMETERS) &> /dev/null
	@echo "New certificates created"

.PHONY: gen_secret_keys
gen_secret_keys:
	@python -c "import secrets; print('SECRET_KEY=', secrets.token_hex(100), sep='')" > $(SECRET_KEY_FILE)
	@echo "Generated Django secret key."

.PHONY: collect_static
collect_static: up
	$(DC) exec gradebook python manage.py collectstatic

.PHONY: _init
_init: gen_ssl_certs gen_secret_keys
	$(DC) build

.PHONY: init
init: _init collect_static

.PHONY: up
up:
	@$(DC) up -d
