#!/bin/bash

icecast -c /usr/share/icecast/icecast.xml -b

exec "$@"
