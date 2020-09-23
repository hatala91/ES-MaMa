#!/bin/bash
cd "$(
    cd "$(dirname "$0")"
    pwd
)"

export PYTHONPATH=.
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PYTHON_VERSION=3.7

if [ -z "$(command -v python${PYTHON_VERSION})" ]; then
    echo "python${PYTHON_VERSION} not available. Please install it."
    exit 1
fi

# -----------------------------------------------------------------------------
# PUBLIC FUNCTIONS
# -----------------------------------------------------------------------------
function update_environment() {
    python${PYTHON_VERSION} -m poetry env use ${PYTHON_VERSION}
    python${PYTHON_VERSION} -m poetry install || exit 1
}

function rebuild_environment() {
    rm -rf .venv
    python${PYTHON_VERSION} -m poetry config virtualenvs.create true
    python${PYTHON_VERSION} -m poetry config virtualenvs.in-project true
    update_environment
}

# -----------------------------------------------------------------------------
# COMMAND LINE HANDLING
# -----------------------------------------------------------------------------

coms=$(cat $0 | egrep "^function" | grep -v "private_" | awk '{print $2}' | tr "\n" " ")
if [ -z "$1" ]; then
    echo "Select command: $coms"
    exit 1
fi
if [ -z "$(echo $coms | grep $1)" ]; then
    echo "Unknown command. Options: $coms"
    exit 1
fi
command=$1
shift
$command $@
echo "EXIT = $?"