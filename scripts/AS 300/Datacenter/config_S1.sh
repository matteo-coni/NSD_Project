#spines - ip addresses
net add interface swp1 ip add 3.1.4.1/30
net add interface swp2 ip add 3.1.2.1/30
net add loopback lo ip add 3.4.4.4/32

#OSPF
net add ospf router-id  3.4.4.4
net add ospf network 3.4.4.4/32 area 0
net add ospf network 3.1.4.0/30 area 0
net add ospf network 3.1.2.0/30 area 0

#MP-eBGP
net add bgp autonomous-system 65000
net add bgp router-id 3.4.4.4
net add bgp neighbor swp1 remote-as external
net add bgp neighbor swp2 remote-as external
net add bgp evpn neighbor swp1 activate
net add bgp evpn neighbor swp2 activate