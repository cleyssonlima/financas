all: default

default:
	psql -f functions/*.sql -f triggers/*.sql -f views/*.sql

recreate:
	psql -f install.sql

clean: recreate default