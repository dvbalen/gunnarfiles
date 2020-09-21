# gunnarfiles
Experiment with datasette as a sql learning tool

Sets up a [Datasette](https://docs.datasette.io) bundling csv files into a sql DB 
and publishing on an interactive website with an API.

It will also install the [regex_replace sqlite extension](https://github.com/gwenn/sqlite-regex-replace-ext) for more complex text munging.


## Install

Make sure python is installed and it's sqlite3 library supports loading sqlite extensions
```
$ python -V
Python 3.8.2
```
**MacOS Warning** the native sqlite3 on Macs has extensions disabled by default. To get around this limitation you can install Homebrew python or compile/pyenv install while explicitly enabling sqlite extensions. You can then rum `make` with the `PYTHON3` variable set to the python that supports extensions.

Make sure GNU make is installed
```
$ make --version
GNU Make 3.81
```

Make sure GLIB 2.x libraries and headers are available (for regex_replace). On
Mac with homebrew you can run `brew install glib`

Clone the gunnarfiles repo
```
$ git clone https://github.com/dvbalen/gunnarfiles.git
```

## Usage

For the demo just type
```
$ make
```

This will install a python environment will all needed libraries. Create a synthetic CSV file which
will be turned into a datasette, served locally and open a browser to the datasette.

## Stopping

To stop serving the data run
```
$ make stop
```

### Bring your owns CSVs

If you drop a csv into the directory and type `make` the csv's those will be bundled and served 
instead of a demo one being created.

### Environment variables

The following environment variables allow some control over the creation of the demo data or
how it is served in the datasette.

For example to create a datasette with 4000 rows of demo data use the following command
```
$ make ROWS=4000
```

- **ROWS** Number of rows to be created in the demo data (defaults to 2108 rows)
- **CSVFILES** List of CSV files to bundle into the dataset (defaults to all in the directory)
- **DBFILES**  Name of the database combining csv files to be served (defaults to databundle.db)
- **LOGFILE**  Name of the datasette log file (defaults to DBFILES with a .log extension)
- **PORT**     Number of the port the datasette will be available on (defaults to 8001)
- **PYENVD**   Name of the python virtual environment (defaults to .env)
- **PYTHON3**  Path to the python to use to install and run datasette and dependencies (defaults to python3)
