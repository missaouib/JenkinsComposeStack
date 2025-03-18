#!/bin/sh

JENKINS_URL="http://localhost:8080"
MAX_RETRIES=50
SLEEP_INTERVAL=2

echo "Waiting for Jenkins to be ready..."

for i in $(seq 1 $MAX_RETRIES); do
  if curl -fs "$JENKINS_URL/login" | grep -q "Sign in to Jenkins"; then
    echo "✅ Jenkins is running!"
    exit 0
  fi
  echo "Retrying in $SLEEP_INTERVAL seconds... ($i/$MAX_RETRIES)"
  sleep $SLEEP_INTERVAL
done

echo "❌ Jenkins did not start in time!"
exit 1
