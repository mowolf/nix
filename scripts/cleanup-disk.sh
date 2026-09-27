#!/usr/bin/env bash
# Reclaim disk space: nix store GC, dangling docker images/build cache, and
# regenerable app caches. Safe defaults — keeps current nix generation, keeps
# tagged/in-use docker images and volumes.
set -euo pipefail

human_df() {
  df -h / | tail -1
}

echo "== before =="
human_df

echo
echo "== nix: collecting garbage (keeps current generation only) =="
sudo nix-collect-garbage -d

echo
echo "== docker: pruning dangling images =="
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  docker image prune -f
  echo
  echo "== docker: pruning build cache =="
  docker builder prune -f -a
else
  echo "docker not running/available, skipping"
fi

echo
echo "== clearing regenerable app caches =="
rm -rf ~/Library/Caches/"Adobe Camera Raw 2"
mkdir -p ~/Library/Caches/"Adobe Camera Raw 2"
rm -rf ~/Library/Caches/Homebrew/*

if command -v pip3 >/dev/null 2>&1; then
  pip3 cache purge || true
fi

# JetBrains caches can be partially locked while an IDE is running; ignore
# failures on individual files rather than aborting the whole cleanup.
rm -rf ~/Library/Caches/JetBrains/* 2>/dev/null || true

echo
echo "== after =="
human_df

echo
echo "Note: not touched — Docker images/volumes still in use by containers," \
     "and any nix generations other than current were deleted. Run" \
     "'docker system df' to see remaining reclaimable Docker space."
