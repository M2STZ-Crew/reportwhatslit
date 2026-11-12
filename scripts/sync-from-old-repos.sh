#!/usr/bin/env bash
# Bring the old repositories' newest main into backend/ and mobile/, until
# Render, Vercel and the app's releases build from this repository (README).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
git subtree pull --prefix=backend https://github.com/M2STZ-Crew/replit-backend.git main \
  -m "Sync backend/ from replit-backend main"
git subtree pull --prefix=mobile https://github.com/M2STZ-Crew/replit-android.git main \
  -m "Sync mobile/ from replit-android main"
