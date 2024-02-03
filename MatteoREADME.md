- AS100 (entrare prima in vtysh e scrivere conf t) NB: visualizza interfacce con "show int bri"

	R101:

		interface lo
			ip address 1.1.0.1/16
			ip address 1.255.0.1/32

		  interface eth0
		  	ip address 10.0.22.2/30

		  interface eth1
		    ip address 10.0.23.1/30

			router bgp 100
			network 1.1.0.1/16

			#eBGP
			neighbor 10.0.22.1 remote-as 200 
			#iBGP
			network 1.1.0.1/16
			neighbor 1.255.0.2 remote-as 100
			neighbor 1.255.0.2 update-source 1.255.0.1
			neighbor 1.255.0.2 next-hop-self

			router ospf
		    router-id 1.255.0.1
		    network 1.1.0.1/16 area 0
		    network 1.255.0.1/32 area 0
		    network 10.0.23.0/30 area 0
		   


	R102:
		interface lo
			ip address 1.2.0.1/16
			ip address 1.255.0.2/32
			

		  interface eth0
		    ip address 10.0.23.2/30
		    

		  interface eth1
		    ip address 10.0.24.1/30
		    

		  router bgp 100
		  network 1.2.0.1/16
		  neighbor 1.255.0.1 remote-as 100
		  neighbor 1.255.0.1 update-source 1.255.0.2
		  neighbor 1.255.0.1 next-hop-self 
		  neighbor 1.255.0.3 remote-as 100
		  neighbor 1.255.0.3 update-source 1.255.0.2
		  neighbor 1.255.0.3 next-hop-self

		  router ospf
		  router-id 1.255.0.2
		  network 1.2.0.1/16 area 0
		  network 1.255.0.2/32 area 0
		  network 10.0.23.0/30 area 0
		  network 10.0.24.0/30 area 0



	R103:
		interface lo
			ip address 1.3.0.1/16
			ip address 1.255.0.3/32

		interface eth0
			ip address 10.0.33.1/30

		interface eth1
			ip address 10.0.24.2/30

		router bgp 100
		network 1.3.0.1/16
		neighbor 10.0.33.2 remote-as 300
		neighbor 1.255.0.2 remote-as 100
		neighbor 1.255.0.2 update-source 1.255.0.3
		neighbor 1.255.0.2 next-hop-self 

		router ospf
		  router-id 1.255.0.3
		  network 1.3.0.1/16 area 0
		  network 1.255.0.3/32 area 0
		  network 10.0.24.0/30 area 0


- AS200

	R201:

		interface lo
			ip address 2.1.0.1/16
			ip address 2.255.0.1/32

		  interface eth0
		  	ip address 10.0.22.1/30

		  interface eth1
		    ip address 10.0.21.2/30

		  #eBGP
		  router bgp 200
		  network 2.1.0.1/16	
		  neighbor 10.0.22.2 remote-as 100

		  #iBGP
		  neighbor 2.255.0.2 remote-as 200
		  neighbor 2.255.0.2 update-source 2.255.0.1
		  neighbor 2.255.0.2 next-hop-self


		  #ospf
		  router ospf
		  router-id 2.255.0.1
		  network 2.1.0.1/16 area 0
		  network 2.255.0.1/32 area 0
		  network 10.0.21.0/30 area 0



	R202:
		interface lo
			ip address 2.2.0.1/16
			ip address 2.255.0.2/32

		  interface eth0
		  	ip address 10.0.32.1/30

		  interface eth1
		    ip address 10.0.21.1/30

		  #iBGP
		  router bgp 200
		  network 2.2.0.1/16
		  neighbor 2.255.0.1 remote-as 200
		  neighbor 2.255.0.1 update-source 2.255.0.2
		  neighbor 2.255.0.1 next-hop-self

		  #ospf
		  router ospf
		  router-id 2.255.0.2
		  network 2.2.0.1/16 area 0
		  network 2.255.0.2/32 area 0
		  network 10.0.21.0/30 area 0


- AS300

	R301:
		interface lo
			ip address 3.1.0.1/16
			ip address 3.255.0.1/32

		  interface eth0
		  	ip address 10.0.33.2/30

		  interface eth1
		    ip address 10.0.34.1/30

		  #eBGP
		  router bgp 300
		  network 3.1.0.1/16	
		  neighbor 10.0.33.1 remote-as 100

		  #iBGP
		  neighbor 3.255.0.2 remote-as 300
		  neighbor 3.255.0.2 update-source 3.255.0.1
		  neighbor 3.255.0.2 next-hop-self


		  #ospf
		  router ospf
		  router-id 3.255.0.1
		  network 3.1.0.1/16 area 0
		  network 3.255.0.1/32 area 0
		  network 10.0.34.0/30 area 0

	R302:
		interface lo
			ip address 3.2.0.1/16
			ip address 3.255.0.2/32

		  interface eth0
		  	ip address 10.0.34.2/30

		  interface eth1
		    ip address 10.0.44.1/30

		  interface eth2
		  	ip address 10.0.32.1/30


		  #eBGP
		  router bgp 300
		  network 3.2.0.1/16	
		  neighbor 10.0.44.2 remote-as 400

		  #iBGP
		  neighbor 3.255.0.1 remote-as 300
		  neighbor 3.255.0.1 update-source 3.255.0.2
		  neighbor 3.255.0.1 next-hop-self


		  #ospf
		  router ospf
		  router-id 3.255.0.2
		  network 3.2.0.1/16 area 0
		  network 3.255.0.2/32 area 0
		  network 10.0.34.0/30 area 0
		  network 10.0.32.0/30 area 0


- AS400
	
	R401:
		interface lo
			ip address 4.1.0.1/16
			ip address 4.255.0.1/32

		  interface eth0
		  	ip address 10.0.40.2/30

		  interface eth1
		    ip address 10.0.44.2/30

		  #eBGP
		  router bgp 400
		  network 4.1.0.1/16	
		  neighbor 10.0.44.1 remote-as 300

