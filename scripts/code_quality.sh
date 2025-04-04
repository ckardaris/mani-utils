#!/usr/bin/env bash

set -e

LOCATIONS="tests"

echo "=================="
echo "Running 'isort'..."
python3 -m isort $LOCATIONS --settings-file tox.ini
echo OK

echo "=================="
echo "Running 'black'..."
python3 -m black $LOCATIONS --line-length 80
echo OK

echo "==================="
echo "Running 'flake8'..."
python3 -m flake8 $LOCATIONS --config tox.ini
echo OK

echo ----
echo Done
