#!/bin/bash

home='/Users/davidvezzani/Documents/journal/04-apr-2015'
ruby ${home}/create-ics-reminders.rb > out-reminders.ics
open -a Reminders out-reminders.ics
