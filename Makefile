all: default

default:
	find functions/ -type f -exec psql -f {} \;
	find triggers/ -type f -exec psql -f {} \;
	find views/ -type f -exec psql -f {} \;

recreate:
	psql -f install.sql

clean: recreate default