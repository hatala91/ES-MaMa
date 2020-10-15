     _______     _______.       .___  ___.      ___      .___  ___.      ___      
    |   ____|   /       |       |   \/   |     /   \     |   \/   |     /   \     
    |  |__     |   (----` ______|  \  /  |    /  ^  \    |  \  /  |    /  ^  \    
    |   __|     \   \    |______|  |\/|  |   /  /_\  \   |  |\/|  |   /  /_\  \   
    |  |____.----)   |          |  |  |  |  /  _____  \  |  |  |  |  /  _____  \  
    |_______|_______/           |__|  |__| /__/     \__\ |__|  |__| /__/     \__\ 
                                                                              

# ElasticSearch Mapping Manager

Manage you Index Mappings for professional ElasticSearch control.

# Setup

## Installation

At the moment `esmama` is not listed in any repository (tbd). You can however follow these steps for the time being:
1. Clone/ download this repository locally
2. Install the package using `setup.py` provided or any package manager (e. g. https://github.com/python-poetry/poetry)

## Project Initialization

Also project initialization is yet to be implemented. Therefore, you have to provide a simple folder. You can choose the location to your liking and also name the top folder as you wish (`esmama_dir` in the following example): 

 - esmama_dir/
   - versions/
   - env.py

The file `env.py` needs to be executable and define at least the three variables `ELASTIC_HOST`, `ELASTIC_PORT` and `INDEX_PREFIX`.

Example:

```
ELASTIC_HOST = "localhost"
ELASTIC_PORT = "9200"
INDEX_PREFIX = "my_project"
```

# Usage

## Display help

`esmama -h`

```
usage: esmama [-h] -d DIR [-n NAME] [-t TARGET] [-f FORCE] command

positional arguments:
  command               The ES-MaMa action to be executed: init, revision, upgrade or history

optional arguments:
  -h, --help            show this help message and exit
  -d DIR, --dir DIR     Path to the ES-MaMa directory
  -n NAME, --name NAME  Name of the revision to be created
  -t TARGET, --target TARGET
                        Target version ID to down/ upgrade to
  -f FORCE, --force FORCE
                        Force recreate index
```

## Add a new index mapping 

`esmama -d <path/to/your/esmama_dir> -n "Name of the new revision" revision`

This creates a new file in your `versions` directory, titled using an UUID and the chosen name.

## Display the history of index mappings

`esmama -d <path/to/your/esmama_dir> history`

This will display the history of index mappings by their UUID.

## Display the currently active revision

`esmama -d <path/to/your/esmama_dir> current`

This will login to the ElasticSearch cluster defined by the variables in `env.py` and check, if the index is managed by ES-MaMa. If so, the active revision will get displayed.

## Perform a reindex

### Upgrade to newest revision

`esmama -d <path/to/your/esmama_dir> upgrade`

Using the most recent revision in `versions`, the ElasticSearch cluster defined by the variables in `env.py` will get upgraded.
For this, on the one hand the currently active revision is read. On the other hand the most recent revision from your `versions` folder is obtained.
Then a new index is created, titled by the `INDEX_PREFIX` and UUID of the revision. Using the Reindex API from ElasticSearch then all documents are transfered to the new index. The "old" index is deleted and an alias is created for the "new" index by the name of `INDEX_PREFIX` (without any UUID suffix).


If the most recent code revision is not newer than the active revision no changes are applied and a message is displayed.

### Force upgrade to newest revision

Even if the active revision already matches the most recent revision, it might be useful to call the Reindex API anyway. For this you can use the `-f` flag.

`esmama -d <path/to/your/esmama_dir> -f upgrade`

### Reindex to a specific revision

Also, up-/ downgrades to certain revisions are possible using the `-t` flag:

`esmama -d <path/to/your/esmama_dir> -t <UUID> upgrade`
