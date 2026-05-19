#!/bin/bash
# Runs the OpenClaw security audit and sends the report to the Discord #alerts channel

# 1. Run the audit
/home/darrenbell.guest/.npm-global/bin/openclaw security audit > /tmp/audit_report.txt

# 2. Add formatting
echo "**Daily Security Audit Report**" > /tmp/formatted_audit.txt
echo '```' >> /tmp/formatted_audit.txt
cat /tmp/audit_report.txt >> /tmp/formatted_audit.txt
echo '```' >> /tmp/formatted_audit.txt

# 3. Send the message to the Discord #alerts channel using the CLI
/home/darrenbell.guest/.npm-global/bin/openclaw message send \
  --channel discord \
  --account default \
  --target "channel:1505830476399771768" \
  --message "$(cat /tmp/formatted_audit.txt)"

echo "Audit completed and sent to Discord."
