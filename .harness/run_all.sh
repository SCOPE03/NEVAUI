#!/bin/bash
# Runs every example/test in the repo in source mode and reports pass/fail.
cd "$(dirname "$0")/.." || exit 1

# darklua is only needed for bundle-mode runs; prefer whatever is on PATH.
for candidate in "$DARKLUA" /workspace/bin/darklua /usr/local/bin/darklua; do
  if [ -n "$candidate" ] && [ -x "$candidate" ]; then
    export PATH="$(dirname "$candidate"):$PATH"
    break
  fi
done

FILES=(
  Example.lua
  anime_background_example.lua
  chad_sigma_background_example.lua
  dashboard_example.lua
  main_example.lua
  sidebar_example.lua
  style_example.lua
  main.client.lua
  main2.client.lua
  examples/neva_glass_example.lua
  tests/ProgressBar.lua
  tests/200Elements.lua
  tests/SidebarLayout.lua
  main.lua
)
pass=0; fail=0
for f in "${FILES[@]}"; do
  printf '%-42s ' "$f"
  # Examples that pull the library over HttpGet must run in bundle mode; the
  # source-mode stub serves an empty body, which leaves NevaUI nil.
  if grep -q "HttpGet" "$f" 2>/dev/null; then
    mode=""
  else
    mode="--source"
  fi
  out=$(timeout 150 python3 .harness/run_harness.py "$f" $mode 2>&1 | tail -3 | tr '\n' ' ')
  if echo "$out" | grep -q "EXAMPLE RAN OK"; then
    echo "PASS"; pass=$((pass + 1))
  else
    echo "FAIL :: $(echo "$out" | head -c 200)"; fail=$((fail + 1))
  fi
done
echo "----------------------------------------"
echo "passed: $pass, failed: $fail"
