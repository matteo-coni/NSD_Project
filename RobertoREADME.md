# NSD_Project
Lezione BGP basics
Per evitare loop degli announcement BGP (tra i router di transito, ossia quelli interni), ad ogni router è associato un router id.

Comandi utilizzati a lezione
1) vtysh 
Il comando vtysh viene utilizzato in ambienti di rete che utilizzano il software di routing Quagga. Quagga è una suite di software di routing open source che fornisce implementazioni per vari protocolli di routing, come OSPF (Open Shortest Path First), BGP (Border Gateway Protocol), RIP (Routing Information Protocol) e altri. vtysh è un'interfaccia a riga di comando (CLI) che consente agli utenti di accedere al terminale virtuale (VTY) di diversi daemon Quagga in modo unificato.
Per uscire da tale terminale basta scrivere exit.

Ecco alcuni punti chiave riguardo al comando vtysh:

CLI unificata: vtysh fornisce un'interfaccia a riga di comando unificata per gestire e configurare diversi daemon di routing all'interno della suite Quagga. Invece di accedere a sessioni CLI separate per ciascun daemon, gli utenti possono utilizzare vtysh per interagire con essi in modo collettivo.

Accesso a protocolli multipli: Gli utenti possono utilizzare vtysh per configurare e monitorare protocolli di routing come OSPF, BGP, RIP e altri, a seconda dei daemon Quagga in esecuzione.

Navigazione: La struttura di navigazione e comando all'interno di vtysh è simile alle CLI individuali dei protocolli di routing supportati. Gli utenti possono navigare attraverso modalità diverse ed emettere comandi specifici dei protocolli di routing che desiderano configurare.


2) show interface brief oppure show int
Servono per mostrare informzioni delle interfacce.

3) config terminal oppure conf t per entrare nel branch di configurazione
Per ogni router presente occorre:
    -) Occorre fare un loopback interface per materializzare una rete e permettere quindi di esportare range di indirizzi IP pubblici;
    -) configurare i protocolli BGP e OSPF;

Creata la topologia e dopo aver configurato i vari router (meglio salvare le confifurazioni nelle cartelle di persistenza cosi da non doverle scrive ogni volta) fare il ping tra i vari router e analizzare i pacchetti con wireshark.

Utile vedere anche con show ip route la ip table.