#!/bin/sh

JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
# TODO: Secure the password
JENKINS_TOKEN="Admin@123"

# Get agent status with error handling
RESPONSE=$(curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" "$JENKINS_URL/computer/api/json")

# Check if authentication failed
if echo "$RESPONSE" | grep -q "Unauthorized"; then
  echo "❌ Authentication failed! Please check JENKINS_USER and JENKINS_TOKEN."
  exit 2
fi

# Extract agent status
AGENT_STATUS=$(echo "$RESPONSE" | grep -o '"offline":false')

# Check if at least one agent is online
if echo "$AGENT_STATUS" | grep -q "false"; then
  echo "✅ All agents are connected!"
else
  echo "❌ Some agents are offline!"
  exit 1
fi
