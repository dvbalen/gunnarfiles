# Param envs
PYTHON3=python3
ROWS=2108
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
REGEX_EXT_URL=https://github.com/gwenn/sqlite-regex-replace-ext/archive/master.tar.gz
REGEX_EXT_DIR=sqlite-regex-replace-ext-master


.PHONY: all

all: serve

serve: $(DBFILES) $(PYENVD) $(REGEX_EXT_DIR)/glib_replace.so
	$(PYENVD)/bin/datasette $(DATASETTEOPTS) --load-extension=$(REGEX_EXT_DIR)/glib_replace.so $(DBFILES) >  $(LOGFILE) 2>&1 &
	sleep 2
	head -4 $(LOGFILE)
	open "http://localhost:$(PORT)"

$(DBFILES):  $(CSVFILES)
	$(PYENVD)/bin/csvs-to-sqlite $(CSVFILES) "$@"

%.csv: | $(PYENVD) 
	$(PYENVD)/bin/python ./generate_fake_gunnarfile.py $(ROWS) "$@"

$(PYENVD): requirements.txt
	[[ -d "$@" ]] || $(PYTHON3) -mvenv "$@"
	[[ -d "$@" ]] && "$@"/bin/pip install -r "$<" || echo "ERROR Couldn't create the virtualenv $@ !"

stop:
	kill `grep "Started server process" $(LOGFILE) | sed  's/[^0-9]//g' `
	sleep 2
	tail -4 $(LOGFILE)

$(REGEX_EXT_DIR)/glib_replace.so: $(REGEX_EXT_DIR)/glib_replace.c
	cd $(REGEX_EXT_DIR) && gcc -fPIC -O2 -Wall -shared -o glib_replace.so `pkg-config --cflags glib-2.0` glib_replace.c `pkg-config --libs glib-2.0` # from glibc_replace.sh

$(REGEX_EXT_DIR)/glib_replace.c:
	curl -L $(REGEX_EXT_URL) | tar xzvf -
