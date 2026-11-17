# Third-party notices

The read-only ECU protocol queries and binary decoding layout in server.cjs were adapted into a standalone JavaScript implementation using the APsystems ECU Reader integration as a reference.

Upstream: https://github.com/HAEdwin/homeassistant-apsystems_ecu_reader
Reference file: custom_components/apsystems_ecu_reader/ecu_api.py
Upstream copyright notice: Copyright (c) 2025-2027 HAEdwin
Upstream license: Apache License 2.0; full original notice/license retained in third_party/APsystems-ECU-Reader-LICENSE.txt.

Changes: JavaScript/Node built-in socket implementation; supports the observed two-channel inverter data format only; new HTTP server, read-only access policy, persistent local records, CSV export, report layout and Moon Rentals UI. No upstream Python modules are executed or bundled.

This repository is not affiliated with or endorsed by APsystems. APsystems and other product names belong to their owners. Node.js is separately installed software, not bundled here.

No blanket open-source license has been selected for the newly authored dashboard/UI/documentation. Public source visibility is not itself an additional license grant. The upstream Apache-licensed portions retain their original terms.
