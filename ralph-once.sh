#!/bin/bash
# Ralph HITL (Human-in-the-Loop)
# Runs one task from PRD.md, commits, updates progress.txt, then stops for review.
# Usage: ./ralph-once.sh

set -euo pipefail

claude --permission-mode acceptEdits -p \
  "@PRD.md @progress.txt \
1. Read the PRD and progress file. \
2. Find the next incomplete task and implement it. \
3. Run the test suite to verify your changes pass. \
4. Commit your changes with a descriptive message. \
5. Update progress.txt with what you did. \
ONLY DO ONE TASK AT A TIME."
