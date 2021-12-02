#!/bin/bash
set -e

rm -f /headsup-b/tmp/pids/server.pid

exec "$@"