# ARCHITECTURE.md

## Overview
QueueCTL uses SQLite for persistent storage, a CLI to enqueue/manage jobs, worker processes that claim jobs transactionally and execute them, and an Express dashboard for monitoring and DLQ retry.

## Components
- **db/**: DB connection and migrations (creates jobs, dlq, config tables)
- **cli/**: Commander-based CLI (enqueue, worker start, dlq, config, status)
- **core/**: Worker loop and job execution logic (retries/backoff)
- **web/**: Express dashboard (jobs, DLQ, AJAX retry)
- **dist/**: compiled JS artifacts

## Job lifecycle
1. `enqueue` -> job row state='pending'
2. Worker `claimJob()` uses an SQLite transaction to atomically pick and mark `processing`
3. On success -> set `completed`
4. On failure -> increment attempts, set `run_at` = now + backoff
5. On exceeding `max_retries` -> `moveToDLQ()` and `state='dead'`

## Synchronization & safety
- Atomic claim/update is in a DB transaction (prevents duplicate claims)
- Persistent storage ensures jobs survive restarts
