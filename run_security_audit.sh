#!/bin/bash
# Runs the OpenClaw security audit and alerts Discord ONLY if new risks are detected.

# 1. Define known warnings to ignore
EXCLUSIONS="(gateway.control_ui.insecure_auth|config.insecure_or_dangerous_flags|security.trust_model.multi_user_heuristic)"

# 2. Run the audit
REPORT_PATH="/tmp/audit_report.txt"
/home/darrenbell.guest/.npm-global/bin/openclaw security audit --deep > "$REPORT_PATH"

# 3. Check for critical errors (always alert)
CRITICAL_COUNT=$(grep -c "CRITICAL" "$REPORT_PATH")

# 4. Check for warnings (filtering out known ones)
# We look for lines starting with 'WARN' (or the identifier line immediately following) 
# that do NOT match our exclusion list.
NEW_WARNINGS=$(grep -E "^[A-Z]+$" -A 1 "$REPORT_PATH" | grep -vE "^--" | grep -vE "$EXCLUSIONS" | grep -c "WARN")

# Note: The logic above is slightly simplified. A better way is to see if any non-excluded WARN sections exist.
# Let's try a more robust check:
OTHER_RISKS=$(grep -E "^(WARN|CRITICAL)$" -A 1 "$REPORT_PATH" | grep -vE "^(WARN|CRITICAL|--)$" | grep -vE "$EXCLUSIONS")

if [ "$CRITICAL_COUNT" -gt 0 ] || [ -n "$OTHER_RISKS" ]; then
    echo "New security risks detected. Sending alert..."
    
    echo "**SECURITY ALERT: New risks or critical issues detected!**" > /tmp/formatted_audit.txt
    echo '```' >> /tmp/formatted_audit.txt
    cat "$REPORT_PATH" >> /tmp/formatted_audit.txt
    echo '```' >> /tmp/formatted_audit.txt

    /home/darrenbell.guest/.npm-global/bin/openclaw message send \
      --channel discord \
      --account default \
      --target "channel:1505830476399771768" \
      --message "$(cat /tmp/formatted_audit.txt)"
    
    echo "Alert sent to Discord."
else
    echo "Audit clean (only known baseline warnings found). No alert sent."
fi
