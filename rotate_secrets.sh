#!/bin/bash
# Monthly secret rotation

# Set current date for backups
DATE=$(date +%Y%m%d)

# Create backup directory
mkdir -p backups

# Backup existing secrets
cp -r secrets backups/secrets_backup_$DATE

# Create new secrets
mkdir -p secrets

# Generate new API keys and credentials
echo "new_api_key_$(openssl rand -hex 16)" > secrets/api_key.txt
echo "new_db_password_$(openssl rand -hex 32)" > secrets/db_password.txt

# Encrypt all secrets with GPG
for file in secrets/*; do
    gpg --batch --yes --encrypt --recipient "Secret Rotation Key" --output "$file.gpg" "$file"
    rm "$file"  # Remove unencrypted version
    echo "Encrypted $file"
done

echo "Secrets rotated and encrypted successfully"