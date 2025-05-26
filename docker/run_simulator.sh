#!/bin/bash
set -e
xhost +local:docker #
docker compose up
exit 0