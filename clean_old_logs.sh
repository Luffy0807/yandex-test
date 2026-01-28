#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 /path/to/logs DAYS"
  exit 1
fi

DIR="$1"
DAYS="$2"

FILES=$(find "$DIR" -type f -name "*.log" -mtime +"$DAYS")

if [ -z "$FILES" ]; then
  echo "No old log files found"
  exit 0
fi

echo "$FILES"
read -p "Удалить эти файлы? (y/n) " ANSWER

if [ "$ANSWER" = "y" ]; then
  find "$DIR" -type f -name "*.log" -mtime +"$DAYS" -delete
fi
