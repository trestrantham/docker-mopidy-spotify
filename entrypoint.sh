#!/bin/bash

icecast2 -c /usr/share/icecast/icecast.xml -b

exec "$@"
