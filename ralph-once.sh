#!/bin/bash
# Human-in-the-loop: run one section, review, run again.

claude --permission-mode acceptEdits "@PRD.md @progress.txt \
1. Read the PRD and progress file. \
2. Find the next incomplete task and implement it. \
3. If Arelle is available, generate XBRL and validate this field. \
4. Commit your changes with message format: [AMSF Qnum] Short description. \
5. Update progress.txt with what you did. \
ONLY DO ONE TASK AT A TIME."
