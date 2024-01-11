# NSD_Project
Lezione BGP basics
Per evitare loop degli announcement BGP (tra i router di transito, ossia quelli interni), ad ogni router è associato un router id.

Comandi 
1) vtysh 
Il comando vtysh viene utilizzato in ambienti di rete che utilizzano il software di routing Quagga. Quagga è una suite di software di routing open source che fornisce implementazioni per vari protocolli di routing, come OSPF (Open Shortest Path First), BGP (Border Gateway Protocol), RIP (Routing Information Protocol) e altri. vtysh è un'interfaccia a riga di comando (CLI) che consente agli utenti di accedere al terminale virtuale (VTY) di diversi daemon Quagga in modo unificato.
Per uscire da tale terminale basta scrivere exit.

Ecco alcuni punti chiave riguardo al comando vtysh:

CLI unificata: vtysh fornisce un'interfaccia a riga di comando unificata per gestire e configurare diversi daemon di routing all'interno della suite Quagga. Invece di accedere a sessioni CLI separate per ciascun daemon, gli utenti possono utilizzare vtysh per interagire con essi in modo collettivo.

Accesso a protocolli multipli: Gli utenti possono utilizzare vtysh per configurare e monitorare protocolli di routing come OSPF, BGP, RIP e altri, a seconda dei daemon Quagga in esecuzione.

Navigazione: La struttura di navigazione e comando all'interno di vtysh è simile alle CLI individuali dei protocolli di routing supportati. Gli utenti possono navigare attraverso modalità diverse ed emettere comandi specifici dei protocolli di routing che desiderano configurare.


2) show interface brief oppure show int: Servono per mostrare lo stato delle interfacce.
Per configurare una interfaccia, facciamo:
    ```
    interface eth0                     
    ip address 1.0.12.1/24
    ```

3) config terminal oppure conf t per entrare nel branch di configurazione (entro nel branch config)
Per ogni router presente occorre:
    -) Fare un loopback interface per materializzare una rete e permettere quindi di esportare range di indirizzi IP pubblici;
    ```
    interface Loopback0                     
    ip address 1.0.0.1/16 
    ```
    -) configurare i protocolli BGP e OSPF;
        -)per configurare BGP occorre entrare nel sotto-branch (config-router) col seguente comando:
                    router bgp <numero del mio AS>
                    network indirizzo-rete-pubblica
                    neighbor indirizzo-link-tra-router remote-as <numero dello altro AS> 

4) una volta che il router è configurato, sia con le interfacce, che esportando le reti pubbliche per il protocollo BGP, è possibile salvare la configurazione e renderla ed iniettarla in fase di startup col seguente comando:
    copy running-config startup-config



Creata la topologia e dopo aver configurato i vari router fare il ping tra i vari router e analizzare i pacchetti con wireshark.

show ip route: mostra la ip table.

Configurazione OSPF
Il frammento di configurazione che hai fornito sembra essere relativo a OSPF (Open Shortest Path First), un protocollo di routing utilizzato nelle reti informatiche. Analizziamo la configurazione:

1. **router-id 2.255.0.2:**
   - Questo comando imposta l'ID del router OSPF al valore specificato, in questo caso, 2.255.0.2. L'ID del router identifica univocamente il router OSPF all'interno di un Autonomous System (AS) OSPF.

2. **network 2.2.0.0/16 area 0:**
   - Questo comando annuncia la rete 2.2.0.0/16 in OSPF e la colloca nell'area OSPF 0. La designazione "area 0" indica che la rete fa parte dell'area 0 di OSPF, che è l'area principale.

3. **network 2.255.0.2/32 area 0:**
   - Questo comando annuncia l'indirizzo IP specifico 2.255.0.2 come una route per host (/32) in OSPF e lo colloca nell'area OSPF 0.

4. **network 10.0.24.0/30 area 0:**
   - Questo comando annuncia la rete 10.0.24.0/30 in OSPF e la colloca nell'area OSPF 0. La subnet /30 indica una connessione punto-punto.

5. **network 10.0.25.0/30 area 0:**
   - Questo comando annuncia la rete 10.0.25.0/30 in OSPF e la colloca nell'area OSPF 0. Similmente al comando precedente, rappresenta un'altra connessione punto-punto.

In sintesi, questa configurazione sta impostando OSPF su un router, specificando l'ID del router e annunciando diverse reti in OSPF area 0, inclusi indirizzi IP specifici e collegamenti punto-punto. I dettagli della configurazione dipendono dai requisiti specifici e dalla topologia della rete.


Configurazione BGP

Questo frammento di configurazione sembra essere relativo a un router configurato con il protocollo di routing BGP (Border Gateway Protocol). Vediamo cosa fa ciascuna riga della configurazione:

1. **`router bgp 200`:**
   - Questo comando imposta l'AS (Autonomous System) del router a 200, indicando che il router è parte dell'AS 200.

2. **`network 2.2.0.0/16`:**
   - Questo comando annuncia la rete 2.2.0.0/16 nel protocollo BGP. Indica che il router sta annunciando questa rete agli altri router BGP.

3. **`neighbor 2.255.0.4 remote-as 200`:**
   - Questo comando configura la connessione BGP con il vicino (neighbor) che ha l'indirizzo IP 2.255.0.4 e appartiene all'AS 200.

4. **`neighbor 2.255.0.4 update-source 2.255.0.2`:**
   - Questo comando specifica che le connessioni BGP con il vicino 2.255.0.4 devono utilizzare l'indirizzo IP 2.255.0.2 come sorgente per gli aggiornamenti di routing.

5. **`neighbor 2.255.0.4 next-hop-self`:**
   - Questo comando indica al router di impostare se stesso come next-hop per le rotte inviate a 2.255.0.4. In altre parole, il router annuncerà a 2.255.0.4 che il next-hop per le rotte BGP è il proprio indirizzo IP.

6. **`neighbor 2.255.0.5 remote-as 200`:**
   - Simile al punto 3, questo comando configura la connessione BGP con il vicino che ha l'indirizzo IP 2.255.0.5 e appartiene all'AS 200.

7. **`neighbor 2.255.0.5 update-source 2.255.0.2`:**
   - Simile al punto 4, specifica che le connessioni BGP con il vicino 2.255.0.5 devono utilizzare l'indirizzo IP 2.255.0.2 come sorgente per gli aggiornamenti di routing.

8. **`neighbor 2.255.0.5 next-hop-self`:**
   - Simile al punto 5, indica al router di impostare se stesso come next-hop per le rotte inviate a 2.255.0.5.

9. **`neighbor 10.0.12.1 remote-as 100`:**
   - Questo comando configura la connessione BGP con un altro vicino che ha l'indirizzo IP 10.0.12.1 e appartiene all'AS 100.

In breve, questa configurazione stabilisce il router all'interno dell'AS 200, annuncia la rete 2.2.0.0/16, e configura le connessioni BGP con due vicini (2.255.0.4 e 2.255.0.5) nell'AS 200. Inoltre, stabilisce una connessione BGP con un vicino nell'AS 100 (10.0.12.1). La configurazione include anche istruzioni specifiche per l'indirizzo IP di origine degli aggiornamenti e per il next-hop delle rotte inviate ai vicini specifici.


FASE DI CONTROLLO
Come controllare i peer BGP e labella ip in un router, comandi:
1) show ip bgp summary 

Il comando `show ip bgp summary` è utilizzato sui router Cisco per ottenere una panoramica sintetica dello stato delle sessioni BGP (Border Gateway Protocol) attive. Questo comando fornisce informazioni riassuntive sulla connettività BGP, lo stato delle sessioni e altre statistiche importanti. Di seguito, ti fornisco una breve descrizione delle informazioni che puoi ottenere utilizzando il comando `show ip bgp summary`:

1. **Peer BGP:**
   - Il comando mostra un elenco dei peer BGP configurati sul router. Include dettagli come l'indirizzo IP del peer, l'AS number del peer e il numero di sessioni BGP attive.

2. **Stato della Sessione:**
   - Per ogni peer, viene indicato lo stato della sessione BGP. Lo stato può essere "Established" se la connessione BGP è stabilita correttamente, oppure può indicare un altro stato, come "Idle" o "Active," che fornisce informazioni sullo stato attuale della connessione.

3. **Versione del Protocollo:**
   - Mostra la versione del protocollo BGP utilizzata nelle sessioni BGP attive.

4. **Messaggi in Coda:**
   - Indica il numero di messaggi BGP in coda pronti per essere inviati al peer BGP. Questo può essere utile per monitorare l'efficienza della connessione.

5. **Messaggi Non Risposti:**
   - Indica il numero di messaggi BGP inviati al peer per i quali non è stata ricevuta risposta. Un valore diverso da zero può indicare un problema nella connessione o nella comunicazione.

6. **Stato di Peering:**
   - Fornisce una panoramica dello stato generale delle sessioni BGP, indicando il numero totale di peer configurati, il numero di sessioni BGP attive e il numero di sessioni BGP inattive.

7. **Up/Down Time:**
   - Indica quanto tempo è trascorso dall'ultima volta che la connessione BGP è stata stabilita (Up) o dall'ultima volta che è stata persa (Down).

8. **Routing Table Version:**
   - Mostra la versione corrente della tabella di routing BGP sul router.

Il comando `show ip bgp summary` è utile per ottenere una visione rapida dello stato generale delle sessioni BGP su un router Cisco, aiutando gli amministratori di rete a identificare eventuali problemi di connessione o a monitorare le statistiche chiave del protocollo di routing BGP.

2) show ip bgp

Il comando `show ip bgp` è un comando di visualizzazione utilizzato sui router Cisco per ottenere informazioni dettagliate sulla tabella di routing BGP (Border Gateway Protocol). Esso fornisce una panoramica degli annunci BGP, delle rotte apprese, dei percorsi preferiti e di altre informazioni rilevanti per il protocollo di routing BGP. Di seguito, ti fornisco una breve descrizione delle informazioni che puoi ottenere utilizzando il comando `show ip bgp`:

1. **Lista delle Rotte BGP:**
   - Il comando mostra una lista di tutte le rotte BGP apprese dal router. Ogni riga rappresenta una voce nella tabella di routing BGP, che contiene informazioni come l'indirizzo di destinazione, la maschera di rete, il next-hop e altre informazioni pertinenti.

2. **Attributi delle Rotte:**
   - Vengono visualizzati gli attributi BGP associati a ciascuna rotta, come AS Path (percorso attraverso gli Autonomous System), Next Hop (prossimo router di hop), Local Preference (preferenza locale), e così via.

3. **Prefissi Annunciati e Ricevuti:**
   - Il comando mostra anche i prefissi BGP che il router ha annunciato verso i suoi vicini e quelli che ha ricevuto dai suoi vicini BGP.

4. **Stato della Connessione BGP:**
   - Per ogni peer BGP, vengono mostrati dettagli sullo stato della connessione, inclusi gli eventi di aggiornamento recenti, l'indirizzo IP del peer, l'AS number del peer, e lo stato della connessione (Established, Idle, etc.).

5. **Metriche BGP:**
   - Vengono visualizzate le metriche BGP associate a ciascuna rotta, che possono includere il peso, la preferenza locale, la metrica di rete e altri parametri che influenzano la selezione del percorso.

6. **Stato di Selezione del Percorso:**
   - Mostra quali percorsi BGP sono stati selezionati come percorsi preferiti per la trasmissione dei dati. La selezione è influenzata da criteri come la lunghezza dell'AS Path, la preferenza locale, la metrica di rete e altre regole di selezione del percorso BGP.

Il comando `show ip bgp` è uno strumento potente per monitorare e analizzare lo stato del protocollo di routing BGP su un router Cisco.

3) show ip route

Il comando `show ip route` è un comando di visualizzazione utilizzato su dispositivi Cisco (come router e switch) per visualizzare la tabella di routing IP del dispositivo. Questo comando fornisce una panoramica delle rotte IP apprese attraverso i vari protocolli di routing o configurate manualmente. Di seguito, una descrizione delle informazioni che puoi ottenere utilizzando il comando `show ip route`:

1. **Rotte Apprese:**
   - Il comando mostra tutte le rotte IP apprese dal dispositivo. Queste rotte possono essere apprese tramite protocolli di routing dinamici (come OSPF, EIGRP, BGP) o possono essere rotte statiche configurate manualmente.

2. **Dettagli delle Rotte:**
   - Ogni voce nella tabella di routing mostra dettagli come l'indirizzo di rete di destinazione, la maschera di rete, il next-hop (prossimo router di hop), l'interfaccia di uscita e la metrica associata alla rotta.

3. **Rotte Predefinite:**
   - Il comando può mostrare anche la rotta di default (0.0.0.0/0), che è la rotta utilizzata quando non esiste una corrispondenza specifica per l'indirizzo di destinazione.

4. **Protocollo di Routing:**
   - Ogni voce indica il protocollo di routing attraverso il quale è stata appresa la rotta (ad esempio, "O" per OSPF, "S" per Static, "C" per connesse).

5. **Prefisso di Routing:**
   - Indica il prefisso di routing (indirizzo di rete e maschera di sottorete) associato a ogni voce della tabella di routing.

6. **Metrica:**
   - La metrica rappresenta un valore numerico che riflette la "distanza" o la "qualità" della rotta, secondo il protocollo di routing utilizzato. Minore è la metrica, migliore è la rotta.

7. **Stato della Rotta:**
   - Indica se la rotta è attiva e utilizzabile ("C" per connected o "D" per dynamically discovered) o se è inattiva ("H" per hold-down).

Questo comando è fondamentale per la diagnostica di reti e l'analisi delle rotte configurate sul dispositivo. Aiuta a identificare le rotte disponibili, il loro stato e i dettagli associati a ciascuna rotta nella tabella di routing.

4) show ip ospf database

Il comando `show ip ospf database` è utilizzato su dispositivi di rete Cisco per visualizzare informazioni dettagliate sul database di link-state OSPF (Open Shortest Path First). Questo comando offre una visione approfondita degli annunci di stato dei link (LSA - Link State Advertisements) presenti nel database OSPF del router. Di seguito, una descrizione delle informazioni principali che puoi ottenere utilizzando il comando `show ip ospf database`:

1. **Router ID:**
   - Mostra l'ID del router OSPF. Questo è l'identificatore univoco del router all'interno di un sistema autonomo OSPF.

2. **Area ID:**
   - Indica l'ID dell'area OSPF alla quale appartiene il router.

3. **Tipo di Link-State Advertisement (LSA):**
   - Identifica il tipo di LSA presente nel database. I tipi comuni includono LSAs di rete (Type 1), LSAs di collegamento (Type 2), LSAs di rete esterna (Type 5), e così via.

4. **Origine dell'LSA:**
   - Indica il router di origine dell'LSA, fornendo l'ID del router da cui proviene l'annuncio.

5. **Age:**
   - Indica da quanto tempo l'annuncio è presente nel database, misurato in secondi.

6. **Seq Number (Numero di Sequenza):**
   - Rappresenta il numero di sequenza dell'LSA. Viene utilizzato per determinare la versione più recente di un annuncio e risolvere conflitti.

7. **Checksum:**
   - Il valore del checksum dell'LSA per la verifica dell'integrità del messaggio.

8. **Link State ID:**
   - Identifica in modo univoco l'oggetto di origine dell'annuncio (ad esempio, l'indirizzo IP di un router).

9. **Advertising Router:**
   - Indica l'ID del router che ha generato l'annuncio di stato del link.

10. **Options:**
    - Specifica le opzioni di OSPF associate all'annuncio.

Questo comando è utile per ottenere informazioni dettagliate sulla topologia di rete OSPF, inclusi i collegamenti, i router e le reti presenti nella rete. Per una visione più specifica, puoi utilizzare varianti di questo comando come `show ip ospf database router`, `show ip ospf database network`, ecc., per visualizzare tipi specifici di LSAs.

5) show ip bgp

Il comando `show ip bgp` è utilizzato su dispositivi Cisco per visualizzare informazioni sulla tabella di routing BGP (Border Gateway Protocol). Questo comando fornisce una panoramica delle rotte BGP apprese dal router, i dettagli delle rotte, e altre informazioni relative al protocollo di routing BGP. Di seguito, una breve descrizione delle informazioni principali ottenute utilizzando il comando `show ip bgp`:

1. **Prefisso di Rete:**
   - Indica l'indirizzo IP di destinazione della rotta BGP.

2. **Next Hop:**
   - Specifica l'indirizzo IP del successivo router di hop verso cui il traffico dovrebbe essere instradato per raggiungere la destinazione.

3. **Metrica:**
   - Mostra la metrica associata alla rotta, che può variare a seconda del protocollo di routing e delle configurazioni specifiche.

4. **Peso:**
   - Il peso è una metrica locale utilizzata da Cisco BGP per influenzare la selezione del percorso. Un valore più alto indica una preferenza maggiore.

5. **Local Preference:**
   - Indica la preferenza locale assegnata alla rotta BGP. Un valore più alto indica una preferenza maggiore.

6. **AS Path:**
   - Rappresenta il percorso attraverso gli Autonomous System che la rotta ha attraversato. Può essere utilizzato per evitare cicli e determinare la preferenza del percorso.

7. **Origin:**
   - Specifica l'origine della rotta BGP (IGP - Interior Gateway Protocol, EGP - Exterior Gateway Protocol, Incomplete).

8. **Med (Multi-Exit Discriminator):**
   - Mostra il valore MED associato alla rotta. Il MED è utilizzato per influenzare la selezione del percorso quando ci sono più punti di uscita da un AS.

9. **Local AS:**
   - Indica l'AS locale, cioè l'AS a cui appartiene il router.

10. **Community:**
    - Rappresenta le community BGP associate alla rotta. Le community sono etichette utilizzate per applicare politiche specifiche alla rotta.

11. **Originator ID:**
    - Indica l'ID del router che ha originato l'annuncio BGP.

12. **Cluster List:**
    - Mostra l'elenco dei cluster BGP attraversati dalla rotta. Utile per evitare cicli in scenari di route reflection.

13. **Status:**
    - Indica lo stato della rotta BGP (Advertised, Received, Best, etc.).

Questo comando è uno strumento fondamentale per monitorare lo stato delle rotte BGP sul router e può aiutare nella risoluzione dei problemi di routing, nell'analisi della selezione del percorso e nella comprensione della topologia di rete basata su BGP.


Fase di testing, comando:

ping 1.0.0.1 source 2.4.0.1


Il comando `ping 1.0.0.1 source 2.4.0.1` è un comando utilizzato per inviare pacchetti di controllo ICMP Echo Request (ping) a un indirizzo IP di destinazione specifico (1.0.0.1, nel tuo esempio) utilizzando un indirizzo IP di origine specifico (2.4.0.1, nel tuo esempio). Vediamo cosa fa ciascuna parte del comando:

- **ping:** Il comando "ping" è utilizzato per testare la connettività di rete tra il dispositivo sorgente e il dispositivo di destinazione. Invia pacchetti ICMP Echo Request e attende le risposte corrispondenti (Echo Reply).

- **1.0.0.1:** È l'indirizzo IP di destinazione verso cui vengono inviati i pacchetti di ping. In questo caso, 1.0.0.1 è l'indirizzo IP del dispositivo di destinazione.

- **source 2.4.0.1:** Specifica l'indirizzo IP di origine dei pacchetti di ping. I pacchetti di ping inviati al dispositivo di destinazione avranno 2.4.0.1 come indirizzo IP di origine.

Quindi, nel complesso, il comando `ping 1.0.0.1 source 2.4.0.1` invia pacchetti di ping dall'indirizzo IP 2.4.0.1 all'indirizzo IP di destinazione 1.0.0.1. Questo può essere utilizzato per verificare se è possibile raggiungere il dispositivo di destinazione da un particolare indirizzo IP e se il percorso di andata e ritorno è funzionante. Se il dispositivo di destinazione risponde con successo, significa che la connessione è stabilita e funzionante. In caso contrario, potrebbero esserci problemi di connettività o configurazione nella rete.


