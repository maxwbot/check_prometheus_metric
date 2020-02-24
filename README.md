<img align="right" src="https://user-images.githubusercontent.com/225151/75162092-3ef2f780-571d-11ea-8d4e-616ccbd1c924.png" width="200" height="200"/>

`check_prometheus_metric`
=========================
![CI](https://github.com/magenta-aps/check_prometheus_metric/workflows/CI/badge.svg)

Nagios plugin for alerting on Prometheus query results.

# Usage
```
  check_prometheus_metric.sh - Nagios plugin for checking Prometheus metrics.
  
  Usage:
    check_prometheus_metric.sh -H HOST -q QUERY -w FLOAT[:FLOAT] -c FLOAT[:FLOAT]
                               -n NAME [-m METHOD] [-O] [-i] [-p]

  Options:
    -H HOST          URL of Prometheus host to query.
    -q QUERY         Prometheus query, in single quotes, that returns a float.
    -w FLOAT[:FLOAT] Warning level value (must be a float or nagios-interval).
    -c FLOAT[:FLOAT] Critical level value (must be a float or nagios-interval).
    -n NAME          A name for the metric being checked.
    -m METHOD        Comparison method, one of gt, ge, lt, le, eq, ne.
                     (Defaults to ge unless otherwise specified).
    -C CURL_OPTS     Additional flags to curl. Can be passed multiple times. 
                     Options and option values must be passed separately.
                     e.g. -C --connect-timeout -C 10 -C --cacert -C /path/to/ca.crt
    -O               Accept NaN as an "OK" result.
    -i               Print the extra metric information into the Nagios message.
    -p               Add perfdata to check output.

  Examples:
    check_prometheus_metric -q 'up{job=\"job_name\"}' -w :1 -c :1
    # Check that job is up. If not, critical.
    
    check_prometheus_metric -q 'node_load1' -w :0.05 -c :0.1
    # Check load is below 0.05 (warning) and 0.1 (critical).

    check_prometheus_metric -q 'go_threads' -w 15:25 -c :
    # Check thread count is between 15-25, warning if outside this interval.

  Dependencies:
    Requires bash, command, curl, cut, echo, grep, jq and sed to be in $PATH.
```
Note: `nagios-interval` refers to [this syntax](http://nagios-plugins.org/doc/guidelines.html#THRESHOLDFORMAT)

# Nagios configuration
You need to add the following commands to your Nagios configuration to use it:
```
define command {
    command_name check_prometheus
    command_line $USER1$/check_prometheus_metric.sh -H '$ARG1$' -q '$ARG2$' -w '$ARG3$' -c '$ARG4$' -n '$ARG5$' -m '$ARG6$'
}

# check_prometheus, treating a NaN result as ok
define command {
    command_name check_prometheus_nan_ok
    command_line $USER1$/check_prometheus_metric.sh -H '$ARG1$' -q '$ARG2$' -w '$ARG3$' -c '$ARG4$' -n '$ARG5$' -m '$ARG6$' -O
}

# check_prometheus, the first element of the vector is used for the check,
# printing the extra metric information into the Nagios message
define command {
    command_name check_prometheus_extra_info
    command_line $USER1$/check_prometheus_metric.sh -H '$ARG1$' -q '$ARG2$' -w '$ARG3$' -c '$ARG4$' -n '$ARG5$' -m '$ARG6$' -i -t vector
}
```
