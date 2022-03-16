#!/bin/bash

cd ~/MarkLogic-10.0-7v2/Data/Logs
tail -F ErrorLog.txt *_ErrorLog.txt
