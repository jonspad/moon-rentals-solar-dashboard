# Moon Rentals / Solar Monitor

A small, read-only home-network dashboard for APsystems ECU-R Pro production data. No cloud login, packages, build step, tracking or external assets. Uses Node.js built-ins only.

## Setup
1. Install a supported Node.js LTS release from https://nodejs.org if Node is not already installed.
2. Copy `config.example.json` to `config.local.json`.
3. In that local file, set `ecuIp` to your ECU's private LAN address and `lanIp` to this computer's private IPv4 address. Find these in the router's device list and your computer's network settings. Keep port 8765 unless it conflicts.
4. Open a terminal in this folder and run `node server.cjs`.
5. On the host open http://127.0.0.1:8765. On another device connected to the same normal home Wi-Fi, open `http://HOST_PRIVATE_IP:8765` using your configured host address. Do not use guest Wi-Fi if it isolates devices.
6. Bookmark the page or use the phone browser's Add to Home Screen option.
7. Stop a foreground server with Ctrl+C. There is no auto-start or persistence installation.

## Important limitations
- The hosting computer must remain awake, connected to the home LAN, and running the server. If it leaves or sleeps, the dashboard stops. A dedicated always-on home computer is better for long-term use.
- No router or firewall changes are made. Another-device access must be tested on the actual LAN; a same-host LAN-IP test does not prove that a phone can reach it. If blocked, investigate firewall/network isolation before approving any narrowly scoped change.
- Do not port-forward this server or expose it publicly. It is unauthenticated HTTP, for a trusted home LAN only. Anyone able to reach it can read production and inverter information. No inverter controls are exposed.
- DHCP address changes require updating local config. Optional address reservations should be reviewed separately, not assumed.
- Verified against ECU-R Pro firmware 2.1.32A with 10 two-channel inverters. Other protocol variants are deliberately rejected rather than guessed.
- Data is read every 5 minutes. Refresh view reloads the cache, not the ECU. Timestamps distinguish measurement time from retrieval time. Measurement time is Pacific for this initial installation; change the displayed timezone if deploying elsewhere.
- Shows solar generation only, not household consumption, utility import/export, billing savings, or battery state. Recorded total is the ECU's own reported lifetime value.
- Failed reads retain the last reading and visibly flag it as stale. If the backend is unavailable, the page flags displayed data as older readings.

## Files and sharing
- `server.cjs`: local HTTP server and read-only ECU protocol parser.
- `index.html`: responsive dashboard with no external dependencies.
- `config.example.json`: portable setup template.
- `config.local.json`: private deployment configuration, excluded from git.
- `Start-Solar.ps1`: optional foreground PowerShell launcher. Running `node server.cjs` avoids PowerShell execution-policy requirements.
- Logs, local config and PID files must not be committed. No ECU identifier is hardcoded in the shared source; it is read at runtime.

## Protocol references
The read-only ECU and inverter query layout was checked against the APsystems ECU Reader integration source:
https://github.com/HAEdwin/homeassistant-apsystems_ecu_reader/blob/main/custom_components/apsystems_ecu_reader/ecu_api.py

This is an independent local utility, not an official APsystems product. No authentication bypass or password guessing is used.

## Quick handoff for Hovik (no coding required)
1. Put this folder on the computer that will stay at home. Keep that computer on the same Wi-Fi/router as the APsystems ECU.
2. Open OpenAI on that computer, give it access to this folder, and paste the block below.
3. After it verifies the dashboard, open the address it gives you on your phone while connected to home Wi-Fi. Bookmark it. If the phone cannot open it, tell your AI the exact error; do not change firewall settings blindly.

### Paste this into your local AI assistant
> Set up this Moon Rentals / Solar Monitor dashboard on this computer for my APsystems ECU. Read README.md and the source first. Use the current installed Node.js if available; otherwise explain how to install official Node.js LTS from nodejs.org. Find this computer's active private LAN IPv4 address and use non-invasive local discovery to identify my APsystems ECU. Confirm it by a read-only identification query before configuring it. Create config.local.json from config.example.json using the verified ECU and host addresses. Do not copy someone else's addresses. Start the dashboard with node server.cjs and test /api/stats, confirm real current readings and their timestamps, then give me the home-Wi-Fi URL. Walk me through testing that URL on my phone. Do not change my firewall, router, network security, sleep settings, or startup settings without explaining and obtaining my approval. Never enable port forwarding or publish my private config/logs. Tell me that this computer must stay awake and at home. If my ECU uses a different protocol, stop and explain rather than making up readings.

### Simple troubleshooting
- `node` not recognized: install Node.js LTS from its official site, then reopen the terminal.
- `config.local.json` missing: copy config.example.json and enter the two verified private IPv4 addresses.
- `EADDRNOTAVAIL`: host address no longer matches this computer; recheck network settings and update lanIp.
- `EADDRINUSE`: an instance may already be running. Check its URL first; do not kill unrelated processes. Choose another port in local config if needed.
- Dashboard opens but says no data/ECU timed out: check ECU power, cable/Wi-Fi, current ECU address and TCP 8899 reachability. No password guessing is needed.
- Works on computer but not phone: ensure phone is on the same regular home Wi-Fi, not guest Wi-Fi or cellular; use the host's LAN address, not 127.0.0.1. An inbound firewall or router isolation may block it. Any security changes require separate review and approval.
- Stops when laptop closes: expected. Keep the host available, or move this folder to a suitable always-on home computer.
- Old readings: compare the measurement and checked times. Nighttime zero output is normal. A successful connection does not by itself prove the ECU measurement is recent.

Windows, macOS and Linux are supported when a current Node.js LTS runtime is installed. Use `node server.cjs` on every platform; the optional .ps1 launcher is Windows-specific. This project installs no services or scheduled tasks.


## Persistent production records, export and backup
The server appends verified readings to `data/samples.jsonl`. This folder is local-only and excluded from git. Collection begins when this dashboard first runs; it does not retrieve earlier historical data. The ECU's cumulative daily energy is stored as reported, and date-range summaries show the latest observed daily total, not an invented completed-day total. Gaps are unrecorded, never filled with zero.

Use From/To and View range, Export CSV for raw aggregate samples (watts, kWh, measurement time, query time, ECU ID, firmware and inverter counts), or Print / Save PDF for a print-friendly summary. Reports describe production only, not household consumption, export, taxes, deductions or savings. These are not certified accounting or utility records.

For backup, stop the server, copy the entire `data` folder and `config.local.json` to your own private backup location, then restart. Restore by stopping the server and replacing these local files from your backup. History is loaded on restart; an incomplete final JSON line is skipped with a log warning. No cloud backup or third-party transmission is performed. Backups and exports contain device identifiers and production telemetry: share only deliberately. Do not add data/, private config, logs or exports to GitHub.

There is no daily file rotation or retention deletion; monitor disk usage for long-running installations. Current format stores inverter details with each sample so future analysis can retain provenance. Two instances must never write the same history file simultaneously.

## Download this project
On GitHub choose **Code > Download ZIP**, then extract it to a normal folder before following Setup. Do not run from inside the ZIP. If you prefer Git, clone this repository. No npm install is needed.

The repository contains software, not a public live dashboard. GitHub Pages or a remote cloud host cannot reach your ECU on your home network. Your private device readings, config and logs are not included.

See THIRD_PARTY_NOTICES.md for protocol provenance and license notices. No blanket license for newly authored UI/documentation has been selected; public visibility alone is not a license grant.
