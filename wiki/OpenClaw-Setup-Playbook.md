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

## 3. Performance & Stability Patches
These patches were applied to the core runtime to ensure reliability:
- **Discord Connection Timeout:** Increased from 2.5s to 10s in `extensions/discord/dist/channel-Bliqi-Qi.js`.
## 3. Communication Strategy
- **Discord Policy:** Set to `groupPolicy: "disabled"`. This prevents unauthorized inbound group triggers and satisfies the multi-user security heuristic.
- **Reporting:** Outbound reports (like security audits) are pushed via `openclaw message send` from local cron scripts, bypassing conversational routing rules.
- **Direct Messaging:** Private 1:1 interaction is available via the `pairing` policy for trusted operators.
## 4. Model Layout Strategy
- **Claudia (Main):** DeepSeek R1 (Deep Reasoning) for complex tasks.
- **Pulse (Fitness):** Google Gemini 3 Flash Preview for instant, low-latency, and stable conversation.
- **Architect Prime:** OpenAI GPT-5.5 Pro for top-tier frontier capability and stable performance.

## 5. Adding a New Agent
1. Create a dedicated workspace directory: `~/.openclaw/workspace/<name>`.
2. Copy the standard `AGENTS.md` and `IDENTITY.md` templates.
3. Register the agent in `openclaw.json` (keep the JSON minimal to avoid UI schema errors).
4. Create a new Discord bot and follow the **Multi-Bot Architecture** steps above.
