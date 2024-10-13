#!/bin/bash
# user_data.sh

cd /home/ubuntu/TravelMemory/frontend/src

line='export const baseUrl = process.env.REACT_APP_BACKEND_URL || "http://15.152.30.14:3001";'

# Write the line to the file url.js
echo "$line" > url.js


nohup npm start > npm_start.log 2>&1 &
