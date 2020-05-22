#!/bin/sh

ulimit -n 8192

exec "$@"
