ROWS?=2108
CSVFILES = $(wildcard *.csv)
CSVFILES := $(or $(CSVFILES), gunnarfile.csv)
#DBFILES = $(patsubst %.csv,%.db,$(CSVFILES))
DBFILES = databundle.db
LOGFILE = $(patsubst %.db, %.log, $(DBFILES) )
PORT=8001
PYENVD=.env
ifneq ($(findstring gunnarfile.csv,$(CSVFILES)),)
	DATASETTEOPTS= #-o foo
else
	DATASETTEOPTS=
endif


.PHONY: all

all: serve

serve: $(DBFILES) $(PYENVD)
	$(PYENVD)/bin/datasette $(DATASETTEOPTS) $(DBFILES) >  $(LOGFILE) 2>&1 &
	sleep 2
	head -4 $(LOGFILE)
	open "http://localhost:$(PORT)"

$(DBFILES):  $(CSVFILES)
	$(PYENVD)/bin/csvs-to-sqlite $(CSVFILES) "$@"

%.csv: | $(PYENVD) 
	./generate_fake_gunnarfile.py $(ROWS) "$@"

$(PYENVD): requirements.txt
	[[ -d "$@" ]] || python3 -mvenv "$@"
	[[ -d "$@" ]] && "$@"/bin/pip install -r "$<" || echo "ERROR Couldn't create the virtualenv $@ !"

stop:
	kill `grep "Started server process" $(LOGFILE) | sed  's/[^0-9]//g' `
	sleep 2
	tail -4 $(LOGFILE)
