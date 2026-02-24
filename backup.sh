#!/bin/bash

# Jarvis Backup Script
# Backs up memory and skills to GitHub

set -e

REPO_DIR="/home/biodockify/.openclaw/workspace/jarvis-backup"
WORKSPACE="/home/biodockify/.openclaw/workspace"
MEMORY_DIR="$WORKSPACE/memory"
SKILLS_DIR="$WORKSPACE/skills"
MEMORY_REPO_DIR="$REPO_DIR/memory"
SKILLS_REPO_DIR="$REPO_DIR/skills"

DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="$REPO_DIR/backup.log"

echo "========================================" | tee -a "$LOG_FILE"
echo "Jarvis Backup: $DATE" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"

cd "$REPO_DIR"

# Create directories if they don't exist
mkdir -p "$MEMORY_REPO_DIR" "$SKILLS_REPO_DIR"

# Backup memory
echo "Backing up memory..." | tee -a "$LOG_FILE"
if [ -d "$MEMORY_DIR" ]; then
  cp -r "$MEMORY_DIR/"* "$MEMORY_REPO_DIR/" 2>/dev/null || true
  echo "✓ Memory backed up" | tee -a "$LOG_FILE"
else
  echo "✗ Memory directory not found" | tee -a "$LOG_FILE"
fi

# Backup skills
echo "Backing up skills..." | tee -a "$LOG_FILE"
if [ -d "$SKILLS_DIR" ]; then
  cp -r "$SKILLS_DIR/"* "$SKILLS_REPO_DIR/" 2>/dev/null || true
  echo "✓ Skills backed up" | tee -a "$LOG_FILE"
else
  echo "✗ Skills directory not found" | tee -a "$LOG_FILE"
fi

# Check for changes
echo "Checking for changes..." | tee -a "$LOG_FILE"
if [ -z "$(git status --porcelain)" ]; then
  echo "No changes to commit. Backup complete." | tee -a "$LOG_FILE"
  exit 0
fi

# Add all changes
git add -A

# Commit
echo "Committing changes..." | tee -a "$LOG_FILE"
git commit -m "Backup: $DATE" | tee -a "$LOG_FILE"

# Push to GitHub
echo "Pushing to GitHub..." | tee -a "$LOG_FILE"
git push origin main 2>&1 | tee -a "$LOG_FILE"

if [ $? -eq 0 ]; then
  echo "✓ Backup completed successfully" | tee -a "$LOG_FILE"
else
  echo "✗ Backup failed during push" | tee -a "$LOG_FILE"
  exit 1
fi

echo "Backup completed at $(date)" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
