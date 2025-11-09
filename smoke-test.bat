@echo off
echo === QueueCTL Smoke Test ===

echo Enqueue success job
node dist/cli/index.js enqueue smoke_ok "echo smoke ok"

echo Enqueue fail job
node dist/cli/index.js enqueue smoke_fail "wrongcommand"

echo Starting worker for 10 seconds...
start /B node dist/cli/index.js worker start --count 1
timeout /t 10

echo Showing status...
node dist/cli/index.js status

echo Showing DLQ list...
node dist/cli/index.js dlq list

echo === Smoke Test Complete ===
