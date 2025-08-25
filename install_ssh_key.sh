#!/bin/bash

# Usage: ./install_ssh_key.sh "ssh-ed25519 AAAAC3Nz... user@host" myuser

PUBKEY="$1"
USERNAME="$2"
USERHOME=$(eval echo "~$USERNAME")
SSH_DIR="$USERHOME/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"

# Check inputs
if [ -z "$PUBKEY" ] || [ -z "$USERNAME" ]; then
    echo "Usage: $0 \"<public_key>\" <username>"
    exit 1
fi

# Create .ssh folder if missing
if [ ! -d "$SSH_DIR" ]; then
    mkdir -p "$SSH_DIR"
    chown "$USERNAME:$USERNAME" "$SSH_DIR"
    chmod 700 "$SSH_DIR"
fi

# Add key if not already present
grep -q "$PUBKEY" "$AUTH_KEYS" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "$PUBKEY" >> "$AUTH_KEYS"
    echo "Key added to $AUTH_KEYS"
else
    echo "Key already exists in $AUTH_KEYS"
fi

# Set permissions
chown "$USERNAME:$USERNAME" "$AUTH_KEYS"
chmod 600 "$AUTH_KEYS"

echo "✅ SSH key installed successfully for $USERNAME"
