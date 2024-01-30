Configurazione AS 400

- R401
  config t
  interface e1
  ip address 10.0.44.2/30
  no shutdown

  - interfaccia loopback
  interface lo0
  ip address 1.0.0.1/16
  exit

  router bgp 400
  network 4.0.0.0
  neighbor 10.0.44.1 remote-as 300
  exit
  ip route 4.0.0.0/8 Null0
