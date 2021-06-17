#!/bin/sh

body='{
"request": {
   "message": "Build requested by NISP-tools",
   "branch": "master"
}}'

curl -s -X POST \
   -H "Content-Type: application/json" \
   -H "Accept: application/json" \
   -H "Travis-API-Version: 3" \
   -H "Authorization: token $TRAVIS_API_TOKEN" \
   -d "$body" \
   https://api.travis-ci.com/repo/stavnstrup%2Fnisp-nation/requests
