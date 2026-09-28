#!/usr/bin/env sh
set -eu

if ! env | grep -q '^API_BASE_URL='; then
  API_BASE_URL=http://localhost:3000/api
fi

WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

STEP=0

request() {
  STEP=$((STEP + 1))
  NAME=$1
  METHOD=$2
  PATH_PART=$3
  EXPECTED=$4
  BODY=$5
  OUTPUT="$WORK_DIR/response-$STEP.json"

  if [ -n "$BODY" ]; then
    STATUS=$(curl -sS -o "$OUTPUT" -w '%{http_code}' \
      -X "$METHOD" -H 'Content-Type: application/json' \
      --data "$BODY" "$API_BASE_URL$PATH_PART")
  else
    STATUS=$(curl -sS -o "$OUTPUT" -w '%{http_code}' \
      -X "$METHOD" "$API_BASE_URL$PATH_PART")
  fi

  if [ "$STATUS" != "$EXPECTED" ]; then
    echo "FAIL: $NAME — expected HTTP $EXPECTED, got $STATUS"
    cat "$OUTPUT"
    exit 1
  fi

  echo "PASS: $NAME (HTTP $STATUS)"
  LAST_OUTPUT=$OUTPUT
}

assert_json() {
  NAME=$1
  EXPRESSION=$2
  node -e "
    const fs = require('fs');
    const value = JSON.parse(fs.readFileSync(process.argv[1], 'utf8'));
    if (!($EXPRESSION)) {
      console.error('FAIL: ' + process.argv[2]);
      process.exit(1);
    }
  " "$LAST_OUTPUT" "$NAME"
  echo "PASS: $NAME"
}

request "health" GET "/health" 200 ""
assert_json "database health is up" "value.status === 'ok' && value.info?.database?.status === 'up'"

request "places list" GET "/places" 200 ""
assert_json "seed contains at least 50 places" "Array.isArray(value) && value.length >= 50"
assert_json "seed contains media references" "value.some(item => Array.isArray(item.photoUrls) && item.photoUrls.length > 0)"

request "content feed" GET "/feed?limit=5" 200 ""
assert_json "feed returns items" "Array.isArray(value.items) && value.items.length > 0"

request "search" GET "/search?q=%D0%BF%D0%B0%D1%80%D0%BA&limit=5" 200 ""
assert_json "search returns items" "Array.isArray(value.items) && value.items.length > 0"

request "classic route" POST "/routes/classic" 201 \
  '{"radius":5,"lat":45.0428,"lng":41.9734}'
assert_json "route contains waypoints" "Array.isArray(value.waypoints) && value.waypoints.length > 0"

SUFFIX=$(date +%s)
EMAIL="reviewer-$SUFFIX@example.test"
PASSWORD="ReviewOnly-$SUFFIX!"

request "email registration" POST "/auth/register/email" 201 \
  "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\",\"name\":\"Hackathon Reviewer\"}"
assert_json "registration returns access token" "typeof value.token === 'string' && value.token.length > 0"

request "email login" POST "/auth/login/email" 200 \
  "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}"
assert_json "login returns access token" "typeof value.token === 'string' && value.token.length > 0"

echo "All API smoke checks passed."
