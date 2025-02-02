# Target per avviare i container
start:
	@echo "Riavvio i container Docker Compose"
	docker compose up -d

# Target per fermare i container
stop:
	@echo "Fermo e rimuovo i container Docker Compose"
	docker compose down
	docker compose rm -f

# Target per la build dell'immagine
logs:
	@echo "Container logs"
	docker compose logs -f

# Pull delle immagini
pull:
	@echo "Image pull"
	docker compose pull

# Target per la build dell'immagine
#- ./onlyoffice/onlyoffice.crt:/usr/local/share/ca-certificates/onlyoffice.crt
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

onlyoffice-show-token:
	@echo "Visualizzo il token per la connessione da nextcloud a onlyoffice"
	docker exec onlyoffice-documentserver documentserver-jwt-status.sh

onlyoffice-enable-test:
	@echo "Abilito l'ambiente di test su onlyoffice"
	docker exec -it onlyoffice-documentserver supervisorctl start ds:example
	docker exec -it onlyoffice-documentserver sed 's,autostart=false,autostart=true,' -i /etc/supervisor/conf.d/ds-example.conf
	
#nextcloud-setup-onlyoffice:
	#@echo "Abilito il certificato di onlyoffice su nextcloud"
	#echo | openssl s_client -connect onlyoffice.lan:443 2>/dev/null | openssl x509 -outform PEM > onlyoffice/certs/onlyoffice.crt
	#docker exec -it nextcloud update-ca-certificates
	#@JWT_SECRET_BUFFER=$$(docker exec onlyoffice-documentserver /var/www/onlyoffice/documentserver/npm/json -f /etc/onlyoffice/documentserver/local.json 'services.CoAuthoring.secret.session.string' 2>/dev/null | tr -d '\r'); \
	#if [ -z "$$JWT_SECRET_BUFFER" ]; then \
	#	echo "Errore: impossibile ottenere il JWT_SECRET."; \
	#	exit 1; \
	#fi; \
	#echo "JWT_SECRET=$$JWT_SECRET_BUFFER" > .env	
	#docker compose down && docker compose up -d
