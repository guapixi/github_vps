#!/usr/bin/env bash
# 修复 Docker 容器出网
# 根因：宿主同时存在 iptables-legacy 与 iptables-nft 两套表。
#   docker0 (172.17.0.0/16) 的规则在 legacy 表（FORWARD 策略 DROP），
#   而 compose 后建的 br-<id> (172.18.0.0/16) 规则只写进了 nft 表，
#   legacy 表里没有它的放行/MASQUERADE 规则 -> 容器出网被 FORWARD DROP 丢弃。
set -u
NET=windows_default
IFACE=br-$(docker network inspect "$NET" -f "{{.Id}}" | cut -c1-12)
SUBNET=$(docker network inspect "$NET" -f "{{range .IPAM.Config}}{{.Subnet}}{{end}}")
echo "net=$NET iface=$IFACE subnet=$SUBNET"
if [ -z "$SUBNET" ]; then echo "ERROR: cannot resolve subnet"; exit 1; fi
sudo iptables-legacy -t nat -C POSTROUTING -s "$SUBNET" -j MASQUERADE 2>/dev/null || sudo iptables-legacy -t nat -A POSTROUTING -s "$SUBNET" -j MASQUERADE
sudo iptables-legacy -C FORWARD -i "$IFACE" -j ACCEPT 2>/dev/null || sudo iptables-legacy -A FORWARD -i "$IFACE" -j ACCEPT
sudo iptables-legacy -C FORWARD -o "$IFACE" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || sudo iptables-legacy -A FORWARD -o "$IFACE" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
echo DONE_docker_egress_fixed