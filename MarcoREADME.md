#### AS100

![](C:\Users\Marco\AppData\Roaming\marktext\images\2024-02-01-22-09-19-image.png)

- ##### R101
  
  *lorem ipsum*
  
  ```bash
      interface lo
        ip address 1.1.0.1/16 
        ip address 1.255.0.1/32
  
      #MPLS ---------------------------------------
      #spoke
      ip vrf vpnA
      rd 100:0
      route-target export 100:1
      route-target import 100:2
  
      interface eth0
        ip vrf forwarding vpnA
        ip address 10.0.22.2/30
  
      interface eth1
        mpls ip
        ip address 10.0.23.1/30
      #------------------------------- PT.1 -------
  
      #OSPF ---------------------------------------
      router ospf
        router-id 1.255.0.1
        network 1.1.0.1/16 area 0
        network 1.255.0.1/32 area 0
        network 10.0.23.0/30 area 0
  
      #abilitare ldp
      mpls ldp autoconfig
      #------------------------------- END OSPF ---
  
      #BGP/MPLS -----------------------------------
      router bgp 100
        network 1.1.0.1/16
  
        #eBGP
        neighbor 10.0.22.1 remote-as 200 
        #iBGP
        neighbor 1.255.0.2 remote-as 100
        neighbor 1.255.0.2 update-source 1.255.0.1
        neighbor 1.255.0.2 next-hop-self
        neighbor 1.255.0.3 remote-as 100
        neighbor 1.255.0.3 update-source 1.255.0.1
        neighbor 1.255.0.3 next-hop-self
  
        address-family vpnv4
        neighbor 1.255.0.2 activate
        neighbor 1.255.0.2 send-community extended
        neighbor 1.255.0.2 next-hop-self
        neighbor 1.255.0.3 activate
        neighbor 1.255.0.3 send-community extended
        neighbor 1.255.0.3 next-hop-self
        exit-address-family
  
      # configurazione della sottorete appartenente alla vpn
      address-family ipv4 vrf vpnA
      network 10.0.22.0/30
      exit-address-family
  
      # route per inviare i pacchetti della sottorete verso l'AS
      ip route vrf vpnA 10.0.22.0/30
  
      # route per scartare pacchetti con IP pubblico e sorgente 
      # l'AS stesso
      ip route 1.0.0.0 255.0.0.0 Null0 
      #--------------------------- END BGP/MPLS ---
  
      end
  ```

- ##### R102
  
  *lorem ipsum*
  
  ```bash
      interface lo
        ip address 1.2.0.1/16
        ip address 1.255.0.2/32
  
      #MPLS ---------------------------------------
      # hub
        ip vrf vpnA
          rd 100:0
          route-target export 100:2
          route-target import 100:1
  
      interface eth0
        mpls ip
        ip address 10.0.23.2/30
  
      interface eth1
        mpls ip
        ip address 10.0.24.1/30
      #------------------------------- PT.1 -------
  
      #OSPF ---------------------------------------
      router ospf
        router-id 1.255.0.2
        network 1.2.0.1/16 area 0
        network 1.255.0.2/32 area 0
        network 10.0.23.0/30 area 0
        network 10.0.24.0/30 area 0
  
      #abilitare ldp
      mpls ldp autoconfig
      #------------------------------- END OSPF ---
  
      #BGP/MPLS -----------------------------------
      router bgp 100
        network 1.2.0.1/16
  
        #iBGP
        neighbor 1.255.0.1 remote-as 100
        neighbor 1.255.0.1 update-source 1.255.0.2
        neighbor 1.255.0.1 next-hop-self 
        neighbor 1.255.0.3 remote-as 100
        neighbor 1.255.0.3 update-source 1.255.0.2
        neighbor 1.255.0.3 next-hop-self
  
        address-family vpnv4
        neighbor 1.255.0.1 activate
        neighbor 1.255.0.1 send-community extended
        neighbor 1.255.0.1 next-hop-self
        neighbor 1.255.0.3 activate
        neighbor 1.255.0.3 send-community extended
        neighbor 1.255.0.3 next-hop-self
        exit-address-family
  
      # route per scartare pacchetti con IP pubblico e sorgente 
      # l'AS stesso
      ip route 1.0.0.0 255.0.0.0 Null0 
      #--------------------------- END BGP/MPLS ---
  
      end
  ```

- ##### R103
  
  *lorem ipsum*
  
  ```bash
      interface lo
        ip address 1.3.0.1/16
        ip address 1.255.0.3/32
  
      #MPLS ---------------------------------------
      #spoke
        ip vrf vpnA
          rd 100:0
          route-target export 100:1
          route-target import 100:2
  
      interface eth0
        ip vrf forwarding vpnA
        ip address 10.0.33.1/30
  
      interface eth1
        mpls ip
        ip address 10.0.24.2/30
      #------------------------------- PT.1 -------
  
      #OSPF ---------------------------------------
      router ospf
        router-id 1.255.0.3
        network 1.3.0.1/16 area 0
        network 1.255.0.3/32 area 0
        network 10.0.24.0/30 area 0
  
      #abilitare ldp
      mpls ldp autoconfig
      #------------------------------- END OSPF ---
  
      #BGP/MPLS -----------------------------------
      router bgp 100
        network 1.3.0.1/16
  
        #eBGP
        neighbor 10.0.33.2 remote-as 300
        #iBGP
        neighbor 1.255.0.1 remote-as 100
        neighbor 1.255.0.1 update-source 1.255.0.3
        neighbor 1.255.0.1 next-hop-self
        neighbor 1.255.0.2 remote-as 100
        neighbor 1.255.0.2 update-source 1.255.0.3
        neighbor 1.255.0.2 next-hop-self 
  
        address-family vpnv4
        neighbor 1.255.0.1 activate
        neighbor 1.255.0.1 send-community extended
        neighbor 1.255.0.1 next-hop-self
        neighbor 1.255.0.2 activate
        neighbor 1.255.0.2 send-community extended
        neighbor 1.255.0.2 next-hop-self
        exit-address-family
  
      # route per scartare pacchetti con IP pubblico e sorgente 
      # l'AS stesso
      ip route 1.0.0.0 255.0.0.0 Null0 
      #--------------------------- END BGP/MPLS ---
  
      end
  ```

#### AS200

![](C:\Users\Marco\AppData\Roaming\marktext\images\2024-02-01-23-45-20-image.png)

- ##### R201
  
  *lorem ipsum*
  
  ```bash
      interface lo
        ip address 1.1.0.1/16
        ip address 1.255.0.1/32
  
      interface eth0
          ip address 10.0.22.2/30
  
      interface eth1
        ip address 10.0.23.1/30
  
      #OSPF ---------------------------------------
      router ospf
        router-id 1.255.0.1
        network 1.1.0.1/16 area 0
        network 1.255.0.1/32 area 0
        network 10.0.23.0/30 area 0
      #------------------------------- END OSPF ---
  
      #BGP ----------------------------------------
      router bgp 100
        network 1.1.0.1/16
  
        #eBGP
        neighbor 10.0.22.1 remote-as 200 
        #iBGP
        network 1.1.0.1/16
        neighbor 1.255.0.2 remote-as 100
        neighbor 1.255.0.2 update-source 1.255.0.1
        neighbor 1.255.0.2 next-hop-self
      #------------------------------- END BGP ----
  
    end
  ```

- ##### R202
  
  *lorem ipsum*
  
  ```bash
      interface lo
        ip address 2.2.0.1/16
        ip address 2.255.0.2/32
  
      interface eth0
          ip address 10.0.32.1/30
  
      interface eth1
        ip address 10.0.21.1/30
  
      #OSPF ---------------------------------------
      router ospf
        router-id 2.255.0.2
        network 2.2.0.1/16 area 0
        network 2.255.0.2/32 area 0
        network 10.0.21.0/30 area 0
      #------------------------------- END OSPF ---
  
      #BGP ----------------------------------------
      router bgp 200
        network 2.2.0.1/16
  
        #iBGP
        neighbor 2.255.0.1 remote-as 200
        neighbor 2.255.0.1 update-source 2.255.0.2
        neighbor 2.255.0.1 next-hop-self
      #------------------------------- END BGP ----
  
   end
  ```

#### AS300

![](C:\Users\Marco\AppData\Roaming\marktext\images\2024-02-01-23-53-42-image.png)

- ##### R301
  
  *lorem ipsum*
  
  ```bash
      interface lo
        ip address 3.1.0.1/16
        ip address 3.255.0.1/32
  
      interface eth0
          ip address 10.0.33.2/30
  
      interface eth1
        ip address 10.0.34.1/30
  
      #OSPF ---------------------------------------
      router ospf
        router-id 3.255.0.1
        network 3.1.0.1/16 area 0
        network 3.255.0.1/32 area 0
        network 10.0.34.0/30 area 0
      #------------------------------- END OSPF ---
  
      #BGP ----------------------------------------
      router bgp 300
        network 3.1.0.1/16
  
        #eBGP    
        neighbor 10.0.33.1 remote-as 100
        #iBGP
        neighbor 3.255.0.2 remote-as 300
        neighbor 3.255.0.2 update-source 3.255.0.1
        neighbor 3.255.0.2 next-hop-self
      #------------------------------- END BGP ----
  
   end
  ```

- ##### R302
  
  *lorem ipsum*
  
  ```bash
      interface lo
        ip address 3.2.0.1/16
        ip address 3.255.0.2/32
  
      interface eth0
          ip address 10.0.34.2/30
  
      interface eth1
        ip address 10.0.44.1/30
  
      interface eth2
          ip address 10.0.32.1/30
  
      #OSPF ---------------------------------------
      router ospf
        router-id 3.255.0.2
        network 3.2.0.1/16 area 0
        network 3.255.0.2/32 area 0
        network 10.0.34.0/30 area 0
        network 10.0.32.0/30 area 0
      #------------------------------- END OSPF ---
  
      #BGP ----------------------------------------
      router bgp 300
        network 3.2.0.1/16
        #eBGP    
        neighbor 10.0.44.2 remote-as 400
        #iBGP
        neighbor 3.255.0.1 remote-as 300
        neighbor 3.255.0.1 update-source 3.255.0.2
        neighbor 3.255.0.1 next-hop-self
      #------------------------------- END BGP ----
  
   end
  ```

#### AS400

![](C:\Users\Marco\AppData\Roaming\marktext\images\2024-02-02-00-02-11-image.png)

- ##### R401
  
  *lorem ipsum*
  
  ```bash
      interface lo
        ip address 4.1.0.1/16
        ip address 4.255.0.1/32
  
      interface eth0
          ip address 10.0.40.2/30
  
      interface eth1
        ip address 10.0.44.2/30
  
      #BGP ----------------------------------------
      router bgp 400
        network 4.1.0.1/16
      
        #eBGP    
        neighbor 10.0.44.1 remote-as 300
      #------------------------------- END BGP ----
  
   end
  ```
