#!/bin/bash

function helper {
	line=$1
	ip=$(echo ${line} | awk '{print $2}' | cut -d "(" -f2 | cut -d ")" -f1)
	domain=$(echo ${line} | awk '{print $2}')

	# validate ip address
	if [[ ${ip} =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		whois=$(whois -h v4.whois.cymru.com $ip | awk 'NR==2')
		asn=$(echo ${whois} | awk '{print $1}')
		asname=$(echo ${whois} | awk '{print $5}')
		if [[ "${asn}" == "NA" ]]; then
			asn="*"
			asname="*"
		fi
		if [[ "${asn}" != "${last_asn}" ]]; then
			# print AS line
			[[ ${DEBUG} != "DEBUG" ]] || echo -e "${AS_LP} | ${asn} | ${asname}"
			AS_LP=$[${AS_LP}+1]
			if [[ "${asn}" != "*" ]]; then
				result+=${asn}" "
			fi
		fi
		IP_LP=$[${IP_LP}+1]
		[[ ${DEBUG} != "DEBUG" ]] || echo -e "\t${IP_LP} | ${domain} | (${ip})"
		last_asn=${asn}
	fi
}

function main_lookup {
	target=$1
	[[ ${DEBUG} != "DEBUG" ]] || echo "ASRoute to ${target}"

	while read line; do
		helper "${line}"
	done < <(traceroute $1 -q 1 -n | grep -v "*" | sed '2,$p' -n)

	helper "1 ${target} 0"

	[[ ${DEBUG} != "DEBUG" ]] || echo "AS path length: ${AS_LP}"
	[[ ${DEBUG} != "DEBUG" ]] || echo "IP path length: ${IP_LP}"

	echo ${result}
}

last_asn=""
result=""
AS_LP=0
IP_LP=0
DEBUG=$2

main_lookup $1
