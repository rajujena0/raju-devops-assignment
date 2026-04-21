#!/bin/bash
# RDS Backup Script
# Runs daily via cron or AWS EventBridge

set -e

REGION="ap-south-2"
DB_IDENTIFIER="devops-assignment-db"
DATE=$(date +%Y-%m-%d-%H%M)
SNAPSHOT_ID="backup-${DB_IDENTIFIER}-${DATE}"
RETENTION_DAYS=7

echo "Starting backup: $SNAPSHOT_ID"

# Create RDS snapshot
aws rds create-db-snapshot \
  --db-instance-identifier "$DB_IDENTIFIER" \
  --db-snapshot-identifier "$SNAPSHOT_ID" \
  --region "$REGION"

echo "Snapshot created: $SNAPSHOT_ID"

# Delete snapshots older than RETENTION_DAYS
echo "Cleaning up snapshots older than $RETENTION_DAYS days..."

aws rds describe-db-snapshots \
  --db-instance-identifier "$DB_IDENTIFIER" \
  --region "$REGION" \
  --query "DBSnapshots[?SnapshotCreateTime<='$(date -d "-${RETENTION_DAYS} days" --utc +%Y-%m-%dT%H:%M:%SZ)'].DBSnapshotIdentifier" \
  --output text | tr '\t' '\n' | while read snapshot; do
    if [ -n "$snapshot" ]; then
      echo "Deleting old snapshot: $snapshot"
      aws rds delete-db-snapshot \
        --db-snapshot-identifier "$snapshot" \
        --region "$REGION"
    fi
  done

echo "Backup complete: $SNAPSHOT_ID"
