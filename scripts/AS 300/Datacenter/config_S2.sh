#spines - ip addresses
net add interface swp1 ip add 3.2.1.1/30
net add interface swp2 ip add 3.1.3.1/30
net add loopback lo ip add 3.3.3.3/32

#OSPF
net add ospf router-id  3.3.3.3
net add ospf network 3.3.3.3/32 area 0
net add ospf network 3.2.1.0/30 area 0
net add ospf network 3.1.3.0/30 area 0


#MP-eBGP
net add bgp autonomous-system 65000
net add bgp router-id 3.3.3.3
net add bgp neighbor swp1 remote-as external
net add bgp neighbor swp2 remote-as external
net add bgp evpn neighbor swp1 activate
net add bgp evpn neighbor swp2 activate