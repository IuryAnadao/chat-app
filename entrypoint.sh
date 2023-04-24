#!/bin/bash

set -e

rm -f /var/www/app/tmp/pids/server.pid

exec "$@"