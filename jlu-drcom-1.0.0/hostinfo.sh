#!/bin/sh
export LANG="en"
IFCONFIG=/sbin/ifconfig
IPCONFIG=/usr/sbin/ipconfig
netinfo_linux() {
    $IFCONFIG -a | awk '{
        if ($2 == "Link") {
            mac = ""; ip = "";
            if ($4 == "HWaddr") {mac = $5}
        }

        pppoe = substr($1,1,3)
        if (pppoe == "ppp") {mac = " "}

        if ($1 == "inet" && mac != "") {sub(/addr:/, ""); ip = $2}
        if (mac != "" && ip != "") {
            if (mac == " ") {
                print "Net\t"ip"\t"mac; ip = ""
            } else {
                print "Net\t"ip"\t"mac"\t0.0.0.0"; ip = ""
            }
        }
    }'
}

netinfo_linux_new() {
    $IFCONFIG -a | awk '{
	if ($2 == "Link") {
		mac = ""; ip = "";
		bCentos7 = 0;
            if ($4 == "HWaddr") {mac = $5}
        }
	else {
		strFlag = substr($2,1,6)
		if (strFlag == "flags=") {mac = ""; ip = "";bCentos7 = 1;}
	}

	pppoe = substr($1,1,3)
	if (pppoe == "ppp") {mac = " "}

	if ($1 == "ether") {mac = $2}
	if ($1 == "inet") {
		if (bCentos7 == 0) {sub(/addr:/, ""); ip = $2}
			else {ip = $2;}
	}

        if (mac != "" && ip != "") {
            if (mac == " ") {
                print "Net\t"ip"\t"mac; ip = ""
            } else {
                print "Net\t"ip"\t"mac"\t0.0.0.0"; ip = ""
            }
        }
    }'
}

netinfo_macosx() {
    for net in `$IFCONFIG -l`
    do
        mac=""
        ip=""
        ip1=""
        ip2=""
        ip3=""
        dhcp_server="0.0.0.0"
        pppoe=`echo $net | cut -c1-3`
        if [ $pppoe != "ppp" ]; then
            dhcp_server=`$IPCONFIG getoption $net server_identifier 2>&1 |grep -v failure`
            if [ -z "$dhcp_server" ]; then
                dhcp_server="0.0.0.0"
            fi
            $IFCONFIG $net | awk -v dhcp_server=$dhcp_server '{
                if ($1 == "ether") {mac = $2}
                if ($1 == "inet" && ip2 != "" && ip3 == "") {ip3 = $2}
                if ($1 == "inet" && ip1 != "" && ip2 == "") {ip2 = $2}
                if ($1 == "inet" && ip != "" && ip1 == "") {ip1 = $2}
                if ($1 == "inet" && ip == "") {ip = $2}
                if (mac != "" && ip != "") {print "Net\t"ip"\t"mac"\t"dhcp_server; ip = ""}
                if (mac != "" && ip1 != "") {print "Net\t"ip1"\t"mac"\t"dhcp_server; ip1 = ""}
                if (mac != "" && ip2 != "") {print "Net\t"ip2"\t"mac"\t"dhcp_server; ip2 = ""}
                if (mac != "" && ip3 != "") {print "Net\t"ip3"\t"mac"\t"dhcp_server; ip3 = ""}
            }'
        else
            mac=""
            $IFCONFIG $net | awk '{
                if ($1 == "inet" && ip == "") {ip = $2}
                if (ip != "") {print "Net\t"ip"\t"mac; ip = ""}
            }'
        fi
    done
}

sysinfo() {
    uname -snr | awk '{print $1"\t"$2"\t"$3}'
}

os_type=`uname -s`

if [ $os_type = "Linux" ]; then
    netinfo_linux_new
fi
if [ $os_type = "Darwin" ]; then
    netinfo_macosx
fi
if [ $os_type = "FreeBSD" ]; then
    netinfo_macosx
fi
if [ $os_type = "OpenBSD" ]; then
    netinfo_macosx
fi
sysinfo


