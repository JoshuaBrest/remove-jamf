#!/bin/sh

# Files and directories
LAUNCH_AGENTS_DIR="/Library/LaunchAgents"
LAUNCH_DAEMONS_DIR="/Library/LaunchDaemons"
# JAMF_CONFIG_FILE="/Library/Application Support/JAMF/.jmf_settings.json"

# Backup directory
BACKUP_DIR="/Users/Shared/JamfBackupDoNotDelete"

# Files to delete
FILES_LAUNCH_AGENT="
    com.jamf.management.agent.plist"
FILES_LAUNCH_DAEMON="
    com.jamf.management.daemon.plist
    com.jamf.management.startup.plist
    com.jamfsoftware.task.1.plist"
    
# Check if backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup directory does not exist. Exiting..."
    exit 1
fi

# Restore files
for file in $FILES_LAUNCH_AGENT; do
    if [ -f "$BACKUP_DIR/$file" ]; then
        echo "Restoring $file..."
        cp -f "$BACKUP_DIR/$file" "$LAUNCH_AGENTS_DIR/$file"
    fi
done

for file in $FILES_LAUNCH_DAEMON; do
    if [ -f "$BACKUP_DIR/$file" ]; then
        echo "Restoring $file..."
        cp -f "$BACKUP_DIR/$file" "$LAUNCH_DAEMONS_DIR/$file"
    fi
done

# Restart JAMF Management
echo "Restarting JAMF Management..."

# Restart computer
shutdown -r now
