#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/stop.sh"
sleep 2
source "$(dirname "${BASH_SOURCE[0]}")/start.sh"
