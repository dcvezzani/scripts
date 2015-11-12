#!/bin/bash

home='/Users/davidvezzani/scripts'
ruby ${home}/create-ics-reminders.rb > out-reminders.ics
open -a Reminders out-reminders.ics
