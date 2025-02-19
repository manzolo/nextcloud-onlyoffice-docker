# Target per avviare i container
start:
	@echo "Riavvio i container Docker Compose"
	docker compose up -d

# Stop Target
stop:
	@echo "Fermo e rimuovo i container Docker Compose"
	docker compose down
	docker compose rm -f

# Log Target 
logs:
	@echo "Container logs"
	docker compose logs -f

# Images Pull
pull:
	@echo "Image pull"
	docker compose pull

# Prepare environment
prepare:
	@echo "Preparo l'ambiente"
	mkdir -p onlyoffice/logs
	mkdir -p onlyoffice/data
	mkdir -p onlyoffice/lib
	mkdir -p onlyoffice/fonts
	mkdir -p onlyoffice/certs
	mkdir -p certs
	mkdir -p nextcloud/data
	mkdir -p nextcloud/db
	openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout certs/server.key -out certs/server.crt -subj "/CN=nextcloud.lan" -addext "subjectAltName=DNS:DNS:nextcloud.lan"
	openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout onlyoffice/certs/onlyoffice.key -out onlyoffice/certs/onlyoffice.crt -subj "/CN=onlyoffice.lan" -addext "subjectAltName=DNS:DNS:onlyoffice.lan"
	@$(MAKE) generate-jwt
    
# Show onlyoffice token
onlyoffice-show-token:
	@echo "Visualizzo il token per la connessione da nextcloud a onlyoffice"
	docker exec onlyoffice-documentserver documentserver-jwt-status.sh

# Enable onlyoffice example
onlyoffice-enable-test:
	@echo "Abilito l'ambiente di test su onlyoffice"
	docker exec -it onlyoffice-documentserver supervisorctl start ds:example
	docker exec -it onlyoffice-documentserver sed 's,autostart=false,autostart=true,' -i /etc/supervisor/conf.d/ds-example.conf

uninstall:
	@echo "Uninstall..."
	docker compose down && docker compose rm -f
	docker compose down --rmi all --volumes

# Genera un segreto JWT casuale e lo salva nel file .env
generate-jwt:
	@JWT_SECRET_BUFFER=$$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 2>/dev/null | tr -d '\r'); \
	if [ -z "$$JWT_SECRET_BUFFER" ]; then \
		echo "Errore: impossibile ottenere il JWT_SECRET."; \
		exit 1; \
	fi; \
	echo "JWT_SECRET=$$JWT_SECRET_BUFFER" > .env
