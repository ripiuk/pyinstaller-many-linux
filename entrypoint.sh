#!/usr/bin/env bash

PYTHON_VERSION=3.6

if [[ -f requirements.txt ]]; then
    pip3.6 install -r requirements.txt
fi

exec /opt/python${PYTHON_VERSION}/bin/pyinstaller $@