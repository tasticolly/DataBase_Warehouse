EXEC = ./connection/execute.py
SCRIPTS_DIR = ../scripts

init:
	docker-compose -f docker-compose.yml up -d --remove-orphans

create:
	@python3 $(EXEC) --file="$(SCRIPTS_DIR)/warehouse_ddl.sql"

insert:
	@python3 $(EXEC) --file="$(SCRIPTS_DIR)/warehouse_inserts.sql"

indexes:
	@python3 $(EXEC) --file="$(SCRIPTS_DIR)/warehouse_indexes.sql"

views:
	@python3 $(EXEC) --file="$(SCRIPTS_DIR)/views.sql"

analysis:
	@python3 "analysis.py"
 kill:
	 @docker kill warehouse
	 @docker rm warehouse

test_select:
	@make init
	@make create
	@make insert
	@make indexes
	@make views
	@make analysis
	@python3 -m pytest --verbosity=2 --showlocals

	@make kill