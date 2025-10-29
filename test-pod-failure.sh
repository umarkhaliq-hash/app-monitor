#!/bin/bash

echo "🔥 Testing Pod Failure Detection..."

# Scale down Jenkins to 0 pods (simulate failure)
echo "📉 Scaling down Jenkins pods to 0..."
kubectl scale deployment jenkins --replicas=0 -n dev-jenkins

echo "⏳ Wait 10 seconds and check Grafana dashboard..."
echo "   - Jenkins gauge should turn RED"
echo "   - Count should drop to 0"
echo "   - Bar chart should show 0 for dev-jenkins"

sleep 10

echo "✅ Restoring Jenkins pods..."
kubectl scale deployment jenkins --replicas=1 -n dev-jenkins

echo "🎯 Dashboard should show:"
echo "   - Jenkins gauge: RED (0) → GREEN (1)"
echo "   - Live detection of pod failure/recovery"