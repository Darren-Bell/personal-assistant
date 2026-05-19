# OpenClaw Setup & Scaling Playbook

This document serves as the master blueprint for replicating or expanding this OpenClaw ecosystem.

## 1. Discord Multi-Bot Architecture
To run multiple bots (identities) on a single gateway:

### Configuration (`openclaw.json`)
Use the `accounts` and `bindings` structure:
- **Accounts:** Define each bot token and `applicationId` under `channels.discord.accounts`.
- **Bindings:** Explicitly map `agentId` to `accountId` in the `bindings` array.
- **Ambient Mode (No-Mention):** Set `requireMention: false` inside each account's `guilds.*` block.

### Discord Permissions
- **Intents:** "Message Content Intent" and "Server Members Intent" must be ON in the Dev Portal.
- **Isolation:** Deny "View Channel" permissions to bots that do not belong in a specific room to prevent deadlocks.
- **Administrator:** Turn OFF the global Administrator permission for bot roles to ensure channel-level overrides work.

## 2. Karpathy-Style Memory (LLM Wiki)
All agents must follow the "Persistent Wiki" pattern:
- `wiki/index.md`: The master catalog.
- `wiki/*.md`: Interlinked knowledge pages.
- `raw/`: Source documents.
- `log.md`: Chronological log of memory operations.

## 3. Communication Strategy
- **Discord Policy:** Set to `groupPolicy: "allowlist"`. Access is strictly restricted via `allowFrom` to specific User IDs (e.g., `1505248096970477650`).
- **Reporting:** Outbound reports (like security audits) are pushed via `openclaw message send` from local cron scripts.
- **Direct Messaging:** Private 1:1 interaction is available via the `allowlist` policy for trusted operators.

## 4. Model Layout Strategy (May 2026 Stable)
- **Claudia (Main):** DeepSeek R1 (Deep Reasoning). Thinking is suppressed in visible chat via `reasoningDefault: off` and strict system prompt overrides.
- **Pulse (Fitness):** Google Gemini 3 Flash Preview. Stable, low-latency, and high context (1M tokens).
- **Architect Prime:** OpenAI GPT-4o. Used as the stable frontier model for high-reliability architectural tasks.

## 5. Security Protocols
- **Automated Audits:** Daily deep security audits are scheduled via cron.
- **Risk Filtering:** The audit script (`run_security_audit.sh`) filters out known baseline warnings (Control UI insecure auth, Multi-user heuristic) and only alerts Discord on *new* risks or critical errors.
- **User Lock:** The `gateway.auth.rateLimit` and `allowFrom` configurations ensure only the primary operator can interact with the system.

## 6. Adding a New Agent
1. Create a dedicated workspace directory: `~/.openclaw/workspace/<name>`.
2. Copy the standard `AGENTS.md` and `IDENTITY.md` templates.
3. Register the agent in `openclaw.json`.
4. Create a new Discord bot and follow the **Multi-Bot Architecture** steps above.
