[IMMAGINE TOPOLOGIA QUI - centrale in div html]

#### BGP

Protocollo di tipo EGP....

#### OSPF

Spiegazione OSPF ed il perche lo abbiamo usato

#### AS100

> `AS100` is a transit Autonomous System providing network access to two customers: `AS200` and `AS300`
> 
> - Configure eBGP peering with `AS200` and `AS300`
> 
> - Configure iBGP peering between border routers
> 
> - Configure OSPF
> 
> - Configure LDP/MPLS in the core network

Per garantire che il routing all'interno dell'AS avvenga in modo ordinato, evitando loop di routing e mantenendo la coerenza della tabella di routing una rotta appresa tramite iBGP non viene mai propagata ad altri peer iBGP non adiacenti. In particolar modo essendo la topologia dell'`AS200` *non full mesh di sessioni iBGP ed essendo sprovvista di BGP Route Reflector*, si utilizza il protocollo MPLS.

MPLS è un protocollo per la distribuzione delle rotte la quale idea chiave è quella di associare un identificatore, chiamato *label*, ad ogni pacchetto per semplificare il loro routing e migliorare l'efficienza del loro trasporto attraverso la rete.

##### MPLS - Initialization

Per aggiungere il supporto al protocollo MPLS in maniera persistente, bisogna aggiungere le seguenti righe tramite la shell di GNS3 VM nel file `/etc/modules`, con il comando

```shell
nano /etc/modules
```

inserendo le righe

```bash
mpls-router
mpls-iptunnel
```

poi si riavvia e si può controllare la coretta installazione con il comando

```shell
show mpls status
```

che se installati correttamente mostra il messaggio `MPLS support enabled: yes`

Dopo aver preconfigurato i moduli kernel per il protocollo MPLS, si scrive all'interno del file di configurazione `/etc/sysctl.conf`, per ogni stazione che fa uso di MPLS, tramite il comando

```shell
vi /etc/sysctl.conf
```

i seguenti parametri in modo tale da abilitare le interfacce che possono accettare i pacchetti MPLS ed impostare il numero di label che possono essere usate

```shell
#per R101
net.mpls.conf.lo.input = 1
net.mpls.conf.eth1.input = 1
net.mpls.platform_labels = 100000

#per R102
net.mpls.conf.lo.input = 1
net.mpls.conf.eth0.input = 1
net.mpls.conf.eth1.input = 1
net.mpls.platform_labels = 100000

#per R103
net.mpls.conf.lo.input = 1
net.mpls.conf.eth1.input = 1
net.mpls.platform_labels = 100000
```

al termine di ogni configurazione, per apportare le modifiche utilizzo il comando

```shell
sysctl -p
```

Dopo aver inizializzato MPLS si procede con la configurazione delle singole stazioni all'interno dell'Autonomous System

- ##### R101
  
  Si procede con la configurazione delle interfacce `eth0`, `eth1` e di loopback `lo`
  
  ```shell
  interface eth0
   ip address 10.0.22.2/30
  exit
  !
  interface eth1
   ip address 10.0.23.1/30
   mpls enable
  exit
  !
  interface lo
   ip address 1.1.0.1/8
   ip address 1.255.0.1/32
   mpls enable
  exit
  !
  ```
  
  Si configura il protocollo OSPF
  
  ```shell
  router ospf
   ospf router-id 1.255.0.1
   network 1.1.0.0/16 area 0
   network 1.255.0.1/32 area 0
   network 10.0.23.0/30 area 0
  exit
  !
  ```
  
  Si configura il protocollo BGP
  
  ```shell
  router bgp 100
   neighbor 1.3.0.1 remote-as 100
   neighbor 1.3.0.1 update-source 1.1.0.1
   neighbor 1.255.0.3 remote-as 100
   neighbor 1.255.0.3 update-source 1.255.0.1
   neighbor 10.0.22.1 remote-as 200
   !
   address-family ipv4 unicast
    network 1.0.0.0/8
    neighbor 1.3.0.1 next-hop-self
    neighbor 1.255.0.3 next-hop-self
   exit-address-family
  exit
  !
  ```
  
  Si configura MPLS seguito dal terminatore `end`
  
  ```shell
  mpls ldp
   router-id 1.255.0.1
   ordered-control
   !
   address-family ipv4
    discovery transport-address 1.255.0.1
    !
    interface eth1
    exit
    !
    interface lo
    exit
    !
   exit-address-family
   !
  exit
  !
  end
  ```
  
  *lorem ipsum*

- ##### R102
  
  Si procede con la configurazione delle interfacce `eth0`, `eth1` e di loopback `lo`
  
  ```shell
  interface eth0
   ip address 10.0.23.2/30
   mpls enable
  exit
  !
  interface eth1
   ip address 10.0.24.1/30
   mpls enable
  exit
  !
  interface lo
   ip address 1.2.0.1/16
   ip address 1.255.0.2/32
   mpls enable
  exit
  !
  ```
  
  Si configura il protocollo OSPF
  
  ```shell
  router ospf
   ospf router-id 1.255.0.2
   network 0.0.0.0/0 area 0
   network 1.2.0.0/16 area 0
   network 1.255.0.2/32 area 0
   network 10.0.23.0/30 area 0
   network 10.0.24.0/30 area 0
  exit
  !
  ```
  
  Si configura MPLS seguito dal terminatore `end`
  
  ```shell
  mpls ldp
   router-id 1.255.0.2
   ordered-control
   !
   address-family ipv4
    discovery transport-address 1.255.0.2
    !
    interface eth0
    exit
    !
    interface eth1
    exit
    !
    interface lo
    exit
    !
   exit-address-family
   !
  exit
  !
  end
  ```
  
  *lorem ipsum*

- ##### R103
  
  Si procede con la configurazione delle interfacce `eth0`, `eth1` e di loopback `lo`
  
  ```shell
  interface eth0
   ip address 10.0.33.1/30
  exit
  !
  interface eth1
   ip address 10.0.24.2/30
   mpls enable
  exit
  !
  interface lo
   ip address 1.255.0.3/32
   ip address 1.3.0.1/16
   mpls enable
  exit
  !
  ```
  
  Si configura il protocollo OSPF
  
  ```shell
  router ospf
   ospf router-id 1.255.0.3
   network 1.3.0.0/16 area 0
   network 1.255.0.3/32 area 0
   network 10.0.24.0/30 area 0
  exit
  !
  ```
  
  Si configura il protocollo BGP
  
  ```shell
  router bgp 100
   neighbor 1.1.0.1 remote-as 100
   neighbor 1.1.0.1 update-source 1.3.0.1
   neighbor 1.255.0.1 remote-as 100
   neighbor 1.255.0.1 update-source 1.255.0.3
   neighbor 10.0.33.2 remote-as 300
   !
   address-family ipv4 unicast
    network 1.0.0.0/8
    neighbor 1.1.0.1 next-hop-self
    neighbor 1.255.0.1 next-hop-self
   exit-address-family
  exit
  !
  ```
  
  Si configura MPLS seguito dal terminatore `end`
  
  ```shell
  mpls ldp
   router-id 1.255.0.3
   ordered-control
   !
   address-family ipv4
    discovery transport-address 1.255.0.3
    !
    interface eth1
    exit
    !
    interface lo
    exit
    !
   exit-address-family
   !
  exit
  !
  end
  ```
  
  *lorem ipsum*

#### AS200

> `AS200` is a customer AS connected to `AS100`, which provides transit services.
> 
> - Setup eBGP peering with `AS100`
> 
> - Configure iBGP peering
> 
> - Configure internal routing as you wish (with or without OSPF)
> 
> - `R203` is not a BGP speaker
>   
>   - It has a default route towards R202
>   
>   - It has a public IP address from the IP address pool of `AS200`
>   
>   - It is the Access Gateway for the LAN attached to it
>     
>     - Configure dynamic NAT
>     
>     - Configure a simple firewall to allow just connections initiated from the LAN
> 
> `Client-200` is sensitive, so it must be configured to use *Mandatory Access Control* and it's a OpenVPN client.

Di seguito si procede con la configurazione delle singole stazioni all'interno dell'Autonomous System

- ##### R201
  
  Si procede con la configurazione delle interfacce `eth0`, `eth1` e di loopback `lo`
  
  ```shell
  interface eth0
   ip address 10.0.22.1/30
  exit
  !
  interface eth1
   ip address 10.0.21.2/30
  exit
  !
  interface lo
   ip address 2.1.0.1/8
   ip address 2.255.0.1/32
  exit
  !
  ```
  
  Si configura il protocollo OSPF
  
  ```shell
  router ospf
   ospf router-id 2.255.0.1
   network 2.0.0.0/8 area 0
   network 2.1.0.0/16 area 0
   network 2.255.0.1/32 area 0
   network 10.0.21.0/30 area 0
  exit
  !
  ```
  
  Si configura il protocollo BGP
  
  ```shell
  router bgp 200
   neighbor 2.255.0.2 remote-as 200
   neighbor 2.255.0.2 update-source 2.255.0.1
   neighbor 10.0.22.2 remote-as 100
   !
   address-family ipv4 unicast
    network 2.0.0.0/8
    network 2.1.0.0/16
    neighbor 2.255.0.2 next-hop-self
   exit-address-family
  exit
  !
  ```
  
  *lorem ipsum*

- ##### R202
  
  Si procede con la configurazione delle interfacce `eth0`, `eth1` e di loopback `lo`
  
  ```shell
  interface eth0
       ip address 2.0.23.1/30
      exit
      !
      interface eth1
       ip address 10.0.21.1/30
      exit
      !
      interface lo
       ip address 2.2.0.1/16
       ip address 2.255.0.2/32
      exit
      !
  ```
  
  Si configura il protocollo OSPF
  
  ```shell
  router ospf
       ospf router-id 2.255.0.2
       network 2.0.0.0/8 area 0
       network 2.0.23.0/30 area 0
       network 2.2.0.0/16 area 0
       network 2.255.0.2/32 area 0
       network 10.0.21.0/30 area 0
      exit
      !
  ```
  
  Si configura il protocollo BGP
  
  ```shell
  router bgp 200
       neighbor 2.0.23.2 remote-as 200
       neighbor 2.0.23.2 update-source 2.2.0.1
       neighbor 2.255.0.1 remote-as 200
       neighbor 2.255.0.1 update-source 2.255.0.2
       !
       address-family ipv4 unicast
        network 2.0.0.0/8
        network 2.2.0.0/16
        neighbor 2.0.23.2 next-hop-self
        neighbor 2.255.0.1 next-hop-self
       exit-address-family
      exit
      !
  ```
  
  Forse prova potrebbe funziona anche senza ??
  
  ```shell
  sysctl -w net.ipv4.ip_forward=1
  ```
  
  *lorem ipsum*

- ##### R203
  
  Si procede con la configurazione delle interfacce `eth0`, `eth1` e della default route verso `R202`
  
  ```shell
  ip addr add 192.168.200.1/24 dev eth1
  ip addr add 2.0.23.2/30 dev eth0
  ip route add default via 2.0.23.1
  ```
  
  Si abilita il forwarding degli indirizzi IP e si definiscono le variabili di ambiente `LAN` e `NET` per utilizzare nomi simbolici più comprensibili per le interfacce di rete del router, dove rispettivamente indicato l'interfaccia relativa alla rete `LAN` verso `Client-200` e l'interfaccia verso l'interno di `AS200`
  
  ```
  sysctl -w net.ipv4.ip_forward=1
  export LAN=eth1
  export NET=eth0     
  ```
  
  Successivamente si configurano le regole del firewall `iptables`:
  
  - `REGOLA-1`: consente il forwarding del traffico in uscita dalla LAN verso l'`AS200`
    
    ```shell
    iptables -A FORWARD -i $LAN -o $NET -j ACCEPT
    ```
  
  - `REGOLA-2`: consente il forwarding del traffico associato a connessioni già stabilite
    
    ```shell
    iptables -A FORWARD -m state --state ESTABLISHED -j ACCEPT
    ```
  
  - `REGOLA-3`: forse da mettere una terza per il ritorno da rifiutare ??
  
  Dopo aver configurato il firewall si configura il NAT (Network Address Translation), in modo tale da modificare l'indirizzo IP sorgente dei pacchetti inviati dalla LAN da `Client-200` con quello dell'interfaccia `NET` quindi quella di `AS200`, tramite il comando
  
  ```shell
  iptables -t nat -A POSTROUTING -o $NET -j MASQUERADE
  ```
  
  Si procede con la configurazione del client della LAN
  
  - ##### Client-200
    
    Si configura l'indirizzo dell'interfaccia `eth1` e della default route verso il router `R203`
    
    ```shell
    ip addr add 192.168.200.2/24 dev eth1
    ip route add default via 192.168.200.1
    ```
    
    *lorem ipsum*

#### AS300

> `AS300` is a customer AS connected to `S100`, which provides transit services. It also has a lateral peering relationship with `AS400`.
> 
> - Setup eBGP peering with `AS400` and `AS100`
> 
> - Configure iBGP peering
> 
> - Configure internal routing as you wish (with or without OSPF)
> 
> - `GW300` is not a BGP speaker
>   
>   - It has a default route towards `R302`
>   
>   - It has a public IP address from the IP address pool of `AS300`
>   
>   - It is the Access Gateway for the Data Center network attached to it
>     
>     - Configure dynamic NAT
>     
>     - It's a OpenVPN server

Di seguito si procede con la configurazione delle singole stazioni all'interno dell'Autonomous System

- ##### R301
  
  Si procede con la configurazione delle interfacce `eth0`, `eth1` e di loopback `lo`
  
  ```shell
  interface eth0
   ip address 10.0.33.2/30
  exit
  !
  interface eth1
   ip address 10.0.34.1/30
  exit
  !
  interface lo
   ip address 3.1.0.1/16
   ip address 3.255.0.1/32
  exit
  !
  ```
  
  Si configura il protocollo OSPF
  
  ```shell
  router ospf
   ospf router-id 3.255.0.1
   network 3.0.0.0/16 area 0
   network 3.1.0.0/16 area 0
   network 3.255.0.1/32 area 0
   network 10.0.34.0/30 area 0
  exit
  !
  ```
  
  Si configura il protocollo BGP
  
  ```shell
  router bgp 300
   neighbor 3.0.23.2 remote-as 300
   neighbor 3.0.23.2 update-source 3.255.0.1
   neighbor 3.255.0.2 remote-as 300
   neighbor 3.255.0.2 update-source 3.255.0.1
   neighbor 10.0.33.1 remote-as 100
   !
   address-family ipv4 unicast
    network 3.0.0.0/8
    network 3.1.0.0/16
    neighbor 3.0.23.2 next-hop-self
    neighbor 3.255.0.2 next-hop-self
   exit-address-family
  exit
  !
  ```
  
  *lorem ipsum*

- ##### R302
  
  Si procede con la configurazione delle interfacce `eth0`, `eth1` e di loopback `lo`
  
  ```shell
  interface eth0
   ip address 10.0.34.2/30
  exit
  !
  interface eth1
   ip address 10.0.44.1/30
  exit
  !
  interface eth2
   ip address 3.0.23.1/30
  exit
  !
  interface lo
   ip address 3.2.0.1/8
   ip address 3.255.0.2/32
  exit
  !
  ```
  
  Si configura il protocollo OSPF
  
  ```shell
  router ospf
   ospf router-id 3.255.0.2
   network 3.0.0.0/8 area 0
   network 3.0.23.0/30 area 0
   network 3.2.0.0/16 area 0
   network 3.255.0.2/32 area 0
   network 10.0.34.0/30 area 0
  exit
  !
  ```
  
  Si configura il protocollo BGP
  
  ```shell
  router bgp 300
   neighbor 3.0.23.2 remote-as 300
   neighbor 3.0.23.2 update-source 3.2.0.1
   neighbor 3.255.0.1 remote-as 300
   neighbor 3.255.0.1 update-source 3.255.0.2
   neighbor 10.0.44.2 remote-as 400
   !
   address-family ipv4 unicast
    network 3.0.0.0/8
    network 3.2.0.0/16
    neighbor 3.0.23.2 next-hop-self
    neighbor 3.255.0.1 next-hop-self
   exit-address-family
  exit
  !
  ```
  
  *lorem ipsum*

- ##### GW300
  
  Si procede con la configurazione delle interfacce `eth0`, `eth1` e di loopback `lo`
  
  asdasd
  
  asdasd
  
  asdsad
  
  - ##### Data Center
    
    asdadasd
    
    asdadsad

#### AS400

> `AS400` has a lateral peering relationship with `AS300`.
> 
> - Setup eBGP peering with `AS400` and `AS100`
> 
> - `R402` is not a BGP speaker
>   
>   - It has a default route towards `R401`
>   
>   - It has a public IP address from the IP address pool of `AS400`
>   
>   - It is the Access Gateway for the LAN attached to it
>     
>     - Configure dynamic NAT
>     
>     - It's a OpenVPN client
> 
> `Client-400` is a simple LAN device with a default route through `R402`.

Di seguito si procede con la configurazione delle singole stazioni all'interno dell'Autonomous System

- ##### R401
  
  Si procede con la configurazione delle interfacce `eth0`, `eth1` e di loopback `lo`
  
  ```shell
  interface eth0
   ip address 4.0.12.2/30
  exit
  !
  interface eth1
   ip address 10.0.44.2/30
  exit
  !
  interface lo
   ip address 4.1.0.1/8
   ip address 4.255.0.1/32
  exit
  !
  ```
  
  Si configura il protocollo OSPF
  
  ```shell
  router ospf
   ospf router-id 4.255.0.1
   network 4.0.0.0/8 area 0
   network 4.0.12.0/30 area 0
   network 4.1.0.0/16 area 0
   network 4.255.0.1/32 area 0
  exit
  !
  ```
  
  Si configura il protocollo BGP
  
  ```shell
  router bgp 400
   neighbor 10.0.44.1 remote-as 300
   !
   address-family ipv4 unicast
    network 4.0.0.0/8
    network 4.1.0.0/16
   exit-address-family
  exit
  !
  ```
  
  *lorem ipsum*

- ##### R402
  
  Si procede con la configurazione delle interfacce `eth0`, `eth1` e della default route verso `R202`
  
  ```shell
  ip addr add 192.168.40.1/24 dev eth1
  ip addr add 4.0.12.1/30 dev eth0
  ip route add default via 4.0.12.2
  ```
  
  Successivamente si abilita il forwarding degli indirizzi ip e si configura il nome simbolico `NET`ed il NAT per il `Client-400` all'interno della LAN collegata
  
  ```shell
  sysctl -w net.ipv4.ip_forward=1 
  
  export NET=eth0
  iptables -t nat -A POSTROUTING -o $NET -j MASQUERADE #abilita il NAT
  ```
  
  Si procede con la configurazione del client della LAN
  
  - #### Client-400
    
    Si configura l'indirizzo dell'interfaccia `eth1` e della default route verso il router `R402`
    
    ```shell
    ip addr add 192.168.40.2/24 dev eth1 
    ip route add default via 192.168.40.1
    ```
    
    *lorem ipsum*

#### Open VPN

PER PRIMA COSA GUARDA SE NELLA CONFIGURAZIONE DEGLI APPARTI VA IN PERSISTENZA root

Per abilitare `easy-rsa` per la generazione automatica delle chiavi e dei certificati necessari al funzionamento della vpn, prima di tutto si procede al pull dell'ultima versione dell'immagine docker `nsdcourse/basenet:latest`, tramite il comando all'interno della shell di GNS3 VM e poi la si riavvia

```shell
docker pull nsdcourse/basenet
```

per inizializzare PKI e fare la build della Certification Authority chiamata `OVPN_NSD_CA`, si eseguono i seguenti comandi all'internod della directory `/usr/share/easy-rsa` del server `GW300`

```shell
./easyrsa init-pki
./easyrsa build-ca nopass
```

si genera poi il certificato del server

```shell
./easyrsa build-server-full GW300 nopass
```

e facciamo la stessa cosa per i client che sono due: `Client-200` e `R402`

```shell
./easyrsa build-client-full Client-200 nopass
./easyrsa build-client-full R402 nopass
```

e poi si generano i parametri di Diffie Hellman per il server ( ricerca di un numero primo con determinate caratteristiche )

```shell
 ./easyrsa gen-dh
```

per garantire la persistenza dei certifiati generati per il server ed i client

```shell
mkdir /root/CA
mkdir /root/CA/GW300
mkdir /root/CA/Client-200
mkdir /root/CA/R402

cp pki/ca.crt /root/CA/
cp pki/issued/GW300.crt /root/CA/GW300/
cp pki/private/GW300.key /root/CA/GW300/
cp pki/dh.pem /root/CA/GW300/

cp pki/issued/Client-200.crt /root/CA/Client-200/
cp pki/private/Client-200.key /root/CA/Client-200/

cp pki/issued/R402.crt /root/CA/R402/
cp pki/private/R402.key /root/CA/R402/
```

ora dobbiamo distribuire il materiale su gli altri client quindi si entra nella shell del client `Client-200` e del client `R402` all'interno di `/root` così da mandarlo in persistenza

```shell
mkdir ovpn
cd ovpn
vim ca.crt
```

e dentro si incolla il contenuto salvato nel server e cioè la chiave relativa, poi faccio la stessa cosa con i cetificati ognuno per il proprio client ( nei file cetificato.crt prendo solo la chiave finale )

```shell
#in Client-200
vim Client-200.crt
vim Client-200.key

#in R402
vim R402.crt
vim R402.key
```

per visualizzare a video il contenuto di una chiava o di un certificato, utilizzo il comando

```shell
cat <nome_nodo>.key
cat <nome_nodo>.crt
```

Dopo aver mandato i certificati in persistenza si procede con la configurazione di rete.

- in `R201``
  
  comandi qui
