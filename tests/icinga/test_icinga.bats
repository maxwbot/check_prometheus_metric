#!/usr/bin/env bats

load ../test_config
load ../test_utils

@test "--- ${BATS_TEST_FILENAME} ---" {
  true
}
# Test pi
@test "Test pi 3.14" {
  set_metric pi 3.14
  wait_for_metric 'scalar(pi)' 3.14
  recheck_service pi
  OUTPUT=$(get_service_state pi)
  [ "${OUTPUT}" -eq 0 ]
}
@test "Test pi 5" {
  set_metric pi 5
  wait_for_metric 'scalar(pi)' 5
  recheck_service pi
  OUTPUT=$(get_service_state pi)
  [ "${OUTPUT}" -eq 1 ]
}
@test "Test pi 2" {
  set_metric pi 2
  wait_for_metric 'scalar(pi)' 2
  recheck_service pi
  OUTPUT=$(get_service_state pi)
  [ "${OUTPUT}" -eq 1 ]
}
@test "Test pi 7" {
  set_metric pi 7
  wait_for_metric 'scalar(pi)' 7
  recheck_service pi
  OUTPUT=$(get_service_state pi)
  [ "${OUTPUT}" -eq 2 ]
}
@test "Test pi 0" {
  set_metric pi 0
  wait_for_metric 'scalar(pi)' 0
  recheck_service pi
  OUTPUT=$(get_service_state pi)
  [ "${OUTPUT}" -eq 2 ]
}
