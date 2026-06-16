# OpenWRT uci-defaults Configuration for WSM20

This configuration file is designed for setting up **WSM20** devices running OpenWRT. The primary deployment scenario involves connecting the WSM20 behind an ISP modem by routing a cable from the **ISP Modem's LAN port** to the **WSM20's WAN port** to provide internet access (**MASTER Mode**). 

To prevent network conflicts (such as DNS and DHCP overlaps) when adding a second or subsequent WSM20 device, secondary units are configured to run in **CLIENT Mode**.

---

## 🚀 Key Features & Structure

* **Package Prerequisites:** The very first line of the file specifies the required packages that must be installed on the WSM20. These must be baked in during a custom image compilation.
* **Dynamic Configuration Variables (Lines 2–25):** The lines contain configuration variables that allow you to easily customize the device behavior without digging deeper into the script. From here, you can modify:
  * Wi-Fi SSID (Network Name) & Password
  * Device Administrator Password
  * LAN IP Address Range
  * Device Operating Mode toggles (**MASTER** or **CLIENT**)

---

## 🛠️ Network Modes Explained

### 1. MASTER Mode (Primary Router)
* **Topology:** Connected directly to the ISP modem (ISP LAN $\rightarrow$ WSM20 WAN).
* **Role:** Acts as the primary local gateway, manages DHCP leases, and handles DNS routing for the network.

### 2. CLIENT Mode (Access Point / Secondary Node)
* **Topology:** Connected downstream to expand wireless coverage.
* **Role:** DHCP and DNS server capabilities are disabled to prevent conflicts with the MASTER node, establishing a clean, unified network infrastructure.
