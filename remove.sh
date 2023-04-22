#!/bin/sh

# Files and directories
LAUNCH_AGENTS_DIR="/Library/LaunchAgents"
LAUNCH_DAEMONS_DIR="/Library/LaunchDaemons"
JAMF_CONFIG_FILE="/Library/Application\ Support/JAMF/.jmf_settings.json"

# Backup directory
BACKUP_DIR="/Users/Shared/JamfBackupDoNotDelete"

# Files to delete
FILES_LAUNCH_AGENT="
    com.jamf.management.agent.plist"
FILES_LAUNCH_DAEMON="
    com.jamf.management.daemon.plist
    com.jamf.management.startup.plist
    com.jamfsoftware.task.1.plist"
    
# Create backup directory if it does not exist
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir "$BACKUP_DIR"
fi

# Asign permsions to backup directory for all read and write
chmod -R 777 "$BACKUP_DIR"

# for each file, if it exists, copy it to the backup directory and delete it

for file in $FILES_LAUNCH_AGENT; do
    if [ -f "$LAUNCH_AGENTS_DIR/$file" ]; then
        chmod 777 "$LAUNCH_AGENTS_DIR/$file"
        cp "$LAUNCH_AGENTS_DIR/$file" "$BACKUP_DIR"
        rm "$LAUNCH_AGENTS_DIR/$file"
    fi
done

for file in $FILES_LAUNCH_DAEMON; do
    if [ -f "$LAUNCH_DAEMONS_DIR/$file" ]; then
        chmod 777 "$LAUNCH_DAEMONS_DIR/$file"
        cp "$LAUNCH_DAEMONS_DIR/$file" "$BACKUP_DIR"
        rm "$LAUNCH_DAEMONS_DIR/$file"
    fi
done

# Replace config file with the following data
DATA_CONFIG="{
  "mcxEnabled" : false,
  "googleBeyondCorpEnabled" : false,
  "hideRestorePartition" : false,
  "beaconMonitoring" : false,
  "blacklist" : []
  "applicationUsage" : false,
  "checkForPoliciesAtLogin" : true,
  "networkStateChange" : false,
  "logUserInfoAtLogin" : false
}"

# Give permissions to JAMF Config file
chmod 777 "$JAMF_CONFIG_FILE"

# Write data to JAMF Config file
echo "$DATA_CONFIG" > "$JAMF_CONFIG_FILE"

# Echo success
echo "Jamf Uninstall Complete"

# Reboot
shutdown -r