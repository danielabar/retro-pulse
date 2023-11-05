db_start:
	docker-compose up

ngrok:
	ngrok http 3000

dev:
	bin/dev

manifest:
	bundle exec rake manifest:generate
	cat app_manifest.json | pbcopy

replant:
	bin/rails db:seed:replant
