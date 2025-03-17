#!/bin/sh

JENKINS_URL="http://localhost:8080"

if ! curl -fs "$JENKINS_URL/login" | grep -q "Sign in to Jenkins"; then
  echo "❌ Jenkins is NOT ready!"
  exit 1
fi

echo "✅ Jenkins is running!"
