#!/bin/bash

cd ~/Library/Application\ Support/MarkLogic/Data/Logs
tail -F ErrorLog.txt *_ErrorLog.txt
