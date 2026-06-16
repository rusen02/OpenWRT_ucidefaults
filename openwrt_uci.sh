opkg install luci-mod-dashboard luci-app-ttyd luci-app-vnstat2 gawk grep sed coreutils-sort

wlan_2_name="wifi24"
wlan_2_password="wifi24"
wlan_2_channel="10"
wlan_2_domain="24ab"
wlan_5_name="wifi50"
wlan_5_password="wifi50"
wlan_5_channel="104"
wlan_5_domain="50ab"

modem_ip_address="192.168.1.1"
master_ip_address="10.0.0.1"
client_ip_address="10.0.0.2"
root_password="toor"

# host_name="WSM20_M"
# host_desc="MASTER DEVICE"
# master_client="master"
# host_name="WSM20_C1"
# host_desc="First Client"
# master_client="client"
host_name="WSM20_C1"
host_desc="First Client"
master_client="client"

# /etc/config/system

(echo "$root_password"; sleep 1; echo "$root_password") | passwd > /dev/null
uci set system.@system[0].hostname="$host_name"
uci set system.@system[0].description="$host_desc"
uci set system.@system[0].zonename="Europe/Istanbul"
uci set system.@system[0].timezone="<+03>-3"
uci del system.ntp.server
uci set system.ntp.enabled="1"
uci set system.ntp.enable_server="1"
uci add_list system.ntp.server="194.27.222.5"
uci add_list system.ntp.server="192.53.103.108"
uci add_list system.ntp.server="139.143.5.30"
uci add_list system.ntp.server="132.163.97.1"
uci add_list system.ntp.server="216.239.35.0"
uci add_list system.ntp.server="162.159.200.1"

uci set dropbear.@dropbear[0].Interface="lan"

# /etc/config/luci

uci set luci.main.lang="en"
uci set luci.main.mediaurlbase="/luci-static/bootstrap-dark"
uci set luci.diag.dns="google.com"
uci set luci.diag.ping="google.com"
uci set luci.diag.route="google.com"

# /etc/config/network

if [ "$master_client" = "master" ]; then

uci set network.lan.ipaddr="$master_ip_address"
uci set network.lan.gateway="$modem_ip_address"
uci set network.lan.netmask="255.255.255.0"
uci set network.lan.proto="static"
uci del network.lan.ip6assign

elif [ "$master_client" = "client" ]; then

uci set network.lan.ipaddr="$client_ip_address"
uci set network.lan.netmask="255.255.255.0"
uci set network.lan.gateway="10.0.0.1"
uci set network.lan.dns="10.0.0.1"
uci set network.lan.proto="static"
uci del network.lan.ip6assign
uci del network.wan
uci del network.@device[0].ports
uci add_list network.@device[0].ports="lan1"
uci add_list network.@device[0].ports="lan2"
uci add_list network.@device[0].ports="lan3"
uci add_list network.@device[0].ports="wan"

fi

uci del network.globals.packet_steering
uci set network.globals.packet_steering="1"
uci del network.wan6

# /etc/config/dhcp

if [ "$master_client" = "client" ]; then

uci set dhcp.lan.ignore="1"
service dnsmasq disable
service dnsmasq stop

fi

# /etc/config/firewall

uci del firewall.@defaults[0].syn_flood
uci set firewall.@defaults[0].synflood_protect="1"
uci set firewall.@defaults[0].flow_offloading="1"
uci set firewall.@defaults[0].flow_offloading_hw="1"

# /etc/config/wireless

uci set wireless.radio0.htmode="HT40"
uci set wireless.radio0.txpower="20"
uci set wireless.radio0.country="TR"
uci set wireless.radio0.channel="$wlan_2_channel"
uci set wireless.default_radio0.ssid="$wlan_2_name"
uci set wireless.default_radio0.key="$wlan_2_password"
uci set wireless.default_radio0.encryption="psk2+ccmp"
uci set wireless.default_radio0.wmm="1"
uci set wireless.default_radio0.ieee80211r="1"
uci set wireless.default_radio0.mobility_domain="$wlan_2_domain"
uci set wireless.default_radio0.ft_over_ds="0"
uci set wireless.default_radio1.ft_psk_generate_local="1"

uci set wireless.radio1.htmode="HE80"
uci set wireless.radio1.txpower="20"
uci set wireless.radio1.country="TR"
uci set wireless.radio1.channel="$wlan_5_channel"
uci set wireless.default_radio1.ssid="$wlan_5_name"
uci set wireless.default_radio1.key="$wlan_5_password"
uci set wireless.default_radio1.encryption="psk2+ccmp"
uci set wireless.default_radio1.wmm="1"
uci set wireless.default_radio1.ieee80211r="1"
uci set wireless.default_radio1.mobility_domain="$wlan_5_domain"
uci set wireless.default_radio1.ft_over_ds="0"
uci set wireless.default_radio1.ft_psk_generate_local="1"

uci set wireless.radio0.disabled="0"
uci set wireless.radio1.disabled="0"

# restart services

service system restart
service sysntpd restart
service dropbear restart
service network restart
service firewall restart
service wpad restart


# master router

if [ "$master_client" = "master" ]; then

# /etc/config/vnstat

uci add_list vnstat.@vnstat[0].interface="wan"
uci del dhcp.lan.ra_slaac
uci commit

fi

# client router

if [ "$master_client" = "client" ]; then

opkg remove luci-app-vnstat2 --autoremove

fi
