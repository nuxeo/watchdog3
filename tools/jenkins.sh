#!/bin/sh -eu
# Launch the tests suit on GNU/Linux and macOS.

# Global variables
PYTHON="python -E -s"

check_vars() {
    # Check required variables
    if [ "${PYTHON_DRIVE_VERSION:=unset}" = "unset" ]; then
        echo "PYTHON_DRIVE_VERSION not defined. Aborting."
        exit 1
    elif [ "${WORKSPACE:=unset}" = "unset" ]; then
        echo "WORKSPACE not defined. Aborting."
        exit 1
    fi
    if [ "${WORKSPACE_DRIVE:=unset}" = "unset" ]; then
        if [ -d "${WORKSPACE}/sources" ]; then
            export WORKSPACE_DRIVE="${WORKSPACE}/sources"
        elif [ -d "${WORKSPACE}/watchdog3" ]; then
            export WORKSPACE_DRIVE="${WORKSPACE}/watchdog3"
        else
            export WORKSPACE_DRIVE="${WORKSPACE}"
        fi
    fi
    export STORAGE_DIR="${WORKSPACE}/deploy-dir"

    echo "    PYTHON_DRIVE_VERSION = ${PYTHON_DRIVE_VERSION}"
    echo "    WORKSPACE            = ${WORKSPACE}"
    echo "    WORKSPACE_DRIVE        = ${WORKSPACE_DRIVE}"
    echo "    STORAGE_DIR          = ${STORAGE_DIR}"

    cd "${WORKSPACE_DRIVE}"
}

install_pyenv() {
    local url="https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer"

    export PYENV_ROOT="${STORAGE_DIR}/.pyenv"
    export PATH="${PYENV_ROOT}/bin:$PATH"

    if ! hash pyenv 2>/dev/null; then
        echo ">>> [pyenv] Downloading and installing"
        curl -L "${url}" | bash
    else
        echo ">>> [pyenv] Updating"
        cd "${PYENV_ROOT}" && git pull && cd -
    fi

    echo ">>> [pyenv] Initializing"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
}

install_python() {
    local version="$1"

    pyenv install --skip-existing "${version}"

    echo ">>> [pyenv] Using Python ${version}"
    pyenv global "${version}"
}

launch_tests() {
    echo ">>> Launching the tests suite"
    ${PYTHON} -b -Wall setup.py test
}

verify_python() {
    local version="$1"
    local cur_version=$(python --version 2>&1 | head -1 | awk '{print $2}')

    echo ">>> Verifying Python version in use"

    if [ "${cur_version}" != "${version}" ]; then
        echo ">>> Current version: ${cur_version}"
        echo ">>> Version required: ${version}"
        exit 1
    fi
}

# The main function, last in the script
main() {
    # Launch operations
    check_vars
    install_pyenv
    install_python "${PYTHON_DRIVE_VERSION}"
    verify_python "${PYTHON_DRIVE_VERSION}"
    launch_tests
}

main
