#!/usr/bin/env bash
# Fails if the Lean sources contain a placeholder proof, a compiler-trusting decision
# procedure, or a new axiom declaration. Run from anywhere: scripts/check_forbidden.sh
set -uo pipefail
cd "$(dirname "$0")/.."

fail=0
check() {
  local name="$1" pattern="$2"
  if grep -rnE --include='*.lean' "$pattern" QuantGrav QuantGrav.lean; then
    echo "FORBIDDEN: $name" >&2
    fail=1
  fi
}

check "placeholder proof" '\bsorry\b'
check "native_decide" '\bnative_decide\b'
check "axiom declaration" \
  '^[[:space:]]*(@\[[^]]*\][[:space:]]*)*((private|protected|public|noncomputable|unsafe)[[:space:]]+)*axiom[[:space:]]'

if [ "$fail" -eq 0 ]; then
  echo "check_forbidden: clean"
fi
exit "$fail"
