#!/bin/bash

NETWORK_NAME=nagios_plugins_testnetwork
PROMETHEUS_NAME=nagios_plugins_prometheus
PROMETHEUS_PORT=9090
PUSHGATEWAY_NAME=nagios_plugins_pushgateway
PUSHGATEWAY_PORT=9091
ICINGA_NAME=icinga2
ICINGA_PORT=5665

PLUGIN_SCRIPT=build/output.sh

export PLUGIN_SCRIPT=${PLUGIN_SCRIPT}
export PROMETHEUS_PORT=${PROMETHEUS_PORT}
export PUSHGATEWAY_PORT=${PUSHGATEWAY_PORT}
export ICINGA_PORT=5665

source tests/test_utils.bash

build_script

start_docker_network
start_prometheus
start_pushgateway
start_icinga

set_metric "pi" "3.14"

echo ""
echo "Waiting until prometheus sees pushed metric"
wait_for_metric "scalar(pi)" 3.14
echo ""

echo "Ordinary tests"
bats tests/*.bats

echo "Integration tests"
bats tests/icinga/*.bats
