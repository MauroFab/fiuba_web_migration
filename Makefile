.PHONY: init ops setup_db deps run run_iex stop

LOG_PATH = ${PGHOST}/log

init:
	if [ ! -d ${PGHOST} ]; then mkdir -p ${PGHOST}; fi
	if [ ! -d ${PGDATA} ]; then initdb ${PGDATA}; fi
	pg_ctl start -l ${LOG_PATH} -o "-k ${PGHOST}" 
	createuser postgres --createdb
	mix deps.get
	cd assets && npm install
	mix ecto.setup
	pg_ctl stop

ops:
	pg_ctl start -l ${LOG_PATH} -o "-k ${PGHOST}"	

deps: 	
	mix deps.get
	cd assets && npm install
	mix ecto.setup

run:
	mix phx.server

run_iex:	
	iex -S mix phx.server

stop:
	pg_ctl stop