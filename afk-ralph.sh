#!/bin/bash
# AFK Ralph Loop for ImmoCRM AMSF Survey (with streaming output)
# Usage: ./afk-ralph.sh <iterations>
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <iterations>"
  echo "Example: $0 33"
  exit 1
fi

# jq filters for stream-json output
stream_text='select(.type == "assistant").message.content[]? | select(.type == "text").text // empty | gsub("\n"; "\r\n") | . + "\r\n\n"'
final_result='select(.type == "result").result // empty'

echo "🔄 Starting AMSF Survey Ralph Loop for $1 iterations (streaming)..."
echo ""

for ((i=1; i<=$1; i++)); do
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🔄 Iteration $i of $1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  tmpfile=$(mktemp)
  trap "rm -f $tmpfile" EXIT

  claude \
    --dangerously-skip-permissions \
    --print \
    --verbose \
    --output-format stream-json \
    "@PRD.md @progress.txt \
    1. Read the PRD and progress file. \
    2. Find the next incomplete task and implement it. \
    3. If Arelle is available, generate XBRL and validate this field. \
    4. Commit your changes with message format: [AMSF Qnum] Short description. \
    5. Update progress.txt with what you did. \
    ONLY WORK ON A SINGLE TASK. \
    If all tasks in progress.txt are complete, output <promise>COMPLETE</promise>." \
  | grep --line-buffered '^{' \
  | tee "$tmpfile" \
  | jq --unbuffered -rj "$stream_text"

  result=$(jq -r "$final_result" "$tmpfile")
  rm -f "$tmpfile"

  echo ""

  if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
    echo "🎉 All tasks complete after $i iterations!"
    exit 0
  fi

  echo "✅ Iteration $i done. Sleeping 5s before next..."
  sleep 5
done

echo "🏁 Completed $1 iterations."
