#!/bin/bash

# REPORT_DATE=2017-12-11 /Users/dcvezzani/scripts/launch-delay-report.sh 0 1

printf "\nCreating report for ${REPORT_DATE}\n"
/Users/dcvezzani/scripts/build-delay-report.sh prodstorm${1}; /Users/dcvezzani/scripts/build-delay-report.sh prodstorm${2}

# bash -c 'for file in node-*.log* node-*.json* ls-*.log* ls-*.json* fs-*.log* fs-*.json* fs-*-delay-report-*.* freeswitch-*-report-by-target-*.* fs-ls-delay-report-* fs-ls-delay-report-* ls-*-report.* node-*-report-by-* freeswitch-*-report-by-target-*.json freeswitch-*-report-by-target-*.txt freeswitch-*-report-by-target-*.txt.compressed.txt fs-*-*.log fs-ls-delay-report-*-*.txt fs-ls-delay-report-summary-*-*.txt fs-prodstorm0-*.log lightstreamer-*-report-by-target-*.json lightstreamer-*-report-by-target-*.txt lightstreamer-*-report-by-target-*.txt.compressed.txt lightstreamer-*-report-by-user-*.json ls-*-*.log freeswitch-*-report-by-user-*.json; do rm "$file"; done'

