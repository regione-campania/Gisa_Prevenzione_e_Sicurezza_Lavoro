<p align="center">
<img src="https://github.com/regione-campania/GISA/blob/main/sicurezza_lavoro/docs/logo-regione-campania.png">
</p>

# PagoPa - G.I.S.A. Sicurezza e prevenzione sui luoghi di lavoro
- [1. Descrizione e finalità del software](#1-descrizione-e-finalità-del-software)
  - [1.1 Pagopa](#11-pagopa)
  - [1.2 Descrizione della struttura repository](#12-descrizione-della-struttura-repository)
  - [1.3 Contesto di utilizzo e casi d'uso](#13-contesto-di-utilizzo-e-casi-duso)
  - [1.4 Piattaforme abilitanti](#14-piattaforme-abilitanti)
  - [1.5 Interoperabilità con i sistemi esterni](#15-interoperabilità-con-i-sistemi-esterni)
  - [1.6 Interoperabilità con i sistemi interni](#16-interoperabilità-con-i-sistemi-interni)
  - [1.7 Link a pagine istituzionali relative al progetto](#17-link-a-pagine-istituzionali-relative-al-progetto)
  - [1.8 Interfaccia web](#18-interfaccia-web)
- [2. Architettura del software](#2-architettura-del-software)
- [3. Requisiti](#3-requisiti)
  - [3.1 Tecnologie utilizzate lato server](#31-tecnologie-utilizzate-lato-server)
  - [3.2 Tecnologie utilizzate lato client](#32-tecnologie-utilizzate-lato-client)
- [4. Riuso ed installazione](#4-riuso-ed-installazione)
  - [4.1 Build dai sorgenti](#41-build-dai-sorgenti)
  - [4.2 Riuso nell'ambito della stessa regione](#42-riuso-nellambito-della-stessa-regione)
  - [4.3 Riuso per enti di altre regioni](#43-riuso-per-enti-di-altre-regioni)
  - [4.4 Librerie esterne](#44-librerie-esterne)
  - [4.5 Creazione e import database](#45-creazione-e-import-database)
  - [4.6 Templates configurazione](#46-templates-configurazione)
  - [4.7 Installazione in un ambiente di sviluppo](#47-Installazione-in-un-ambiente-di-sviluppo)
  - [4.8 Installazione in un ambiente di produzione](#48-Installazione-in-un-ambiente-di-produzione)
- [5. Licenza](#5-licenza)
  - [5.1 Sicurezza lavoro](#51-Sicurezza-lavoro)
  - [5.2 Indirizzo e-mail segnalazioni di sicurezza](#52-indirizzo-e-mail-segnalazioni-di-sicurezza)
  - [5.3 Titolarità: Regione Campania](#53-titolarità-regione-campania)

# **1. Descrizione e finalità del software**

Nel servizio **G.I.S.A. Sicurezza e Prevenzione sui luoghi di lavoro** è presente il modulo: 

- PagoPA



## 1.1 Pagopa

Il sistema è **multi-browser** e **responsive** quindi in grado di adattarsi graficamente in modo automatico al dispositivo con il quale viene utilizzato
(computer con diverse risoluzioni, tablet, smartphone, ecc), riducendo al massimo la necessità dell'utente di ridimensionare e scorrere i contenuti.





![screen](./docs/pagopa.png)

Figura 1. PagoPA





Il link diretto al portale è:
https://sca.gisacampania.it/sicurezzalavoro/






Ruoli abilitati alla gestione PagoPA:


  -  Ispettori SIML delle AA.SS.LL.;
  -  Ispettori SPSAL delle AA.SS.LL..




## **1.2 Descrizione della struttura repository**

  - _./database_   script sql per la creazione della struttura del DB 

  - _./docs_       documentazione varia (cartella contenente file integrati nel readme: immagini, diagrammi, ecc.)  

  - _./pagopa_    sorgenti e struttura di cartelle della piattaforma 


## **1.3 Contesto di utilizzo e casi d'uso**

 Il contesto di utilizzo e casi d'uso del Software sono descritti dettagliatamente nella [guida utente](https://gisasicurezzalavoro.regione.campania.it/assets/Manuale_GISA_Sicurezza_Lavoro_Ispezioni.pdf)
 
## **1.4 Piattaforme abilitanti**

Le piattaforme abilitanti sono:
    - **Autenticazione SPID/CIE**
	
## **1.5 Interoperabilità con i sistemi esterni**

1. **SPID / CIE Regione Campania**
	
## **1.6 Interoperabilità con i sistemi interni**

1. **Ispezioni**


## **1.7 Link a pagine istituzionali relative al progetto**

- [G.I.S.A. - Sicurezza e prevenzione sui luoghi di lavoro](https://gisasicurezzalavoro.regione.campania.it/)

## **1.8 Interfaccia web**

**G.I.S.A. Sicurezza e Prevenzione sui luoghi di lavoro** è dotato di un interfaccia web semplice e intuitiva.
Questa la lista avvisi di pagamento PagoPA: 

![screen](./docs/sicurezza.png)


Figura 2. Rappresentazione Lista avvisi Pagopa


# **2. Architettura del software**

L'architettura software cioè l'organizzazione di base del sistema, espressa dalle sue componenti, dalle relazioni tra di loro e con l'ambiente, e i principi che ne guidano il progetto e l'evoluzione.



![archittetura](./docs/gisa_arch1.png)


Figura 3. Processo registrazione utenti abilitati 



# **3. Requisiti**

## **3.1 Tecnologie utilizzate lato server**
 - [Node.js  >= 16.14](https://nodejs.org/it/)
 - [Angular  >= 13.2](https://angular.io/)
 - [Postgres  15.x ](https://www.postgresql.org/about/news/postgresql-15-released-2526/)
 
## **3.2 Tecnologie utilizzate lato client**
- [Windows](https://www.microsoft.com/it-it/software-download/) (dalla versione 10 in poi)
- **Portatile** e **Responsive** per il mobile.
- In fase di sviluppo le app per **Android** e **iOS**.


 

# **4. Riuso ed installazione**

## **4.1 Build dai sorgenti**

Tecnicamente **G.I.S.A. Sicurezza e Prevenzione sui luoghi di lavoro** è un'applicazione in architettura web sviluppata con linguaggi Javascript/Typescript secondo il pattern _MVC_ (model view controller).

Come le applicazioni di questo genere **G.I.S.A. Sicurezza e Prevenzione sui luoghi di lavoro** è quindi composta da un back-end in funzione di _Model_ (in questo caso l'_RDBMS_ Postgresql) 
una serie di risorse di front-end web (_Angular_) in funzione di _View_
e infine, lato back-end, un webserver _NodeJS_, con il suo framework _Express_. 

In questo repository sono contenuti i _components_, _modules_, _routing_ e _services_ Angular da importare in qualsiasi progetto Angular per riutilizzare il portale PagoPa. I componenti sono responsive e utilizzabili in qualisasi Progressive Web App utilizzabile sia da Desktop che Mobile.

Inoltre è incluso il modulo NodeJs l'integrazione con servizi messi a disposizione da MyPay.
 
## 4.2 Riuso nell'ambito della stessa regione

Nell'ottica del risparmio e della razionalizzazione delle risorse è opportuno che gli enti che insistono sullo stesso territorio regionale utilizzino la modalità **Multi-Tenant** al fine di installare un unico sistema a livello regionale.





## **4.3 Riuso per enti di altre regioni**
Al fine di avvalersi dei benefici del riuso così come concepito dal **CAD** si chiede di notificarlo come indicato nel paragrafo 5.3 al fine di evitare sprechi e frammentazioni.

*Nota: Se lo scopo è avviare un processo di sviluppo per modificare la propria versione di **GISA - SICUREZZA LAVORO**, potrebbe essere il caso di generare prima un proprio fork su GitHub e quindi clonarlo.*

Eseguire il seguente comando:

        git clone \
		  --depth 1  \
		  --filter=blob:none  \
		  --sparse \
		  https://github.com/regione-campania/Gisa_Prevenzione_e_Sicurezza_Lavoro \
		;
		cd Gisa_Prevenzione_e_Sicurezza_Lavoro
		git sparse-checkout set app_pagoPa

Sarà creata la directory sicurezza_lavoro. Da qui in avanti si farà riferimento a questa directory chiamandola "directory base".



## **4.4 Librerie esterne**

Le dipendenze necessarie sono autoinstallanti tramite NPM (Node Package Manager), il gestore di pacchetti ufficiale di NodeJS:

```
cd /NodeJsServer/
npm install
cd ../AngularClient/
npm install
```


## **4.5 Creazione e import database**


Assicurarsi che nel file di configurazione pg_hba.conf sia correttamente configurato l'accesso dell'IP del nodo Tomcat al database: 
```
 host         all         all       <ipapplicativo>       trust
```
```
systemctl reload postgresql.service
```

Creazione Database e import dello schema tramite i seguenti comandi, con _dbuser_ e _dbhost_ adeguatamente valorizzati :

```
psql -U <dbuser> -h <dbhost> -c "create database nome_db "
```

Posizionarsi nella directory _pagopa_ ed eseguire il comando: 

```
psql -U <dbuser> -h <dbhost> -d nome_db < database/pagopa.sql
```

## **4.6 Installazione in un ambiente di sviluppo**

- Clonare il repository _SICUREZZA_LAVORO_ (Vedi paragrafo: 4.3 Riuso per enti di altre regioni):

       git clone \
		  --depth 1  \
		  --filter=blob:none  \
		  --sparse \
		  https://github.com/regione-campania/Gisa_Prevenzione_e_Sicurezza_Lavoro \
		;
		cd Gisa_Prevenzione_e_Sicurezza_Lavoro
		git sparse-checkout set app_pagoPa
		
- Installare _Visual_  _Studio_ _Code_ disponibile al seguente indirizzo: https://code.visualstudio.com/ , e importare i componenti _NodeJsServer_ e _AngularClient_ nei propri progetti.

- Creare ed importare database (Vedi paragrafo: Creazione e import database)

- Importare i moduli, componenti, servizi e routing all'interno del proprio progetto Angular,

- Importare i moduli NodeJS all'interno del proprio server NodeJS.

- Lanciare il server NodeJS:
```
node main.js
```


- Lanciare il client Angular in modalità sviluppatore:
```
ng serve 
```


## **4.7 Installazione in un ambiente di produzione**

- Clonare il repository _app_pagoPa_ (Vedi paragrafo: 4.3 Riuso per enti di altre regioni):
```
   git clone \
		  --depth 1  \
		  --filter=blob:none  \
		  --sparse \
		  https://github.com/regione-campania/Gisa_Prevenzione_e_Sicurezza_Lavoro \
		;
		cd Gisa_Prevenzione_e_Sicurezza_Lavoro
		git sparse-checkout set app_pagoPa
```

- Creare ed importare database (Vedi paragrafo: Creazione e import database)

- Installare dipendenze (Vedi paragrafo: Librerie esterne)

- Compilare il client Angular:
```
ng build --configuration=production
```

- Installare PM2 (https://pm2.keymetrics.io/)
```
npm install pm2 -g
```

- Lanciare il server NodeJS con PM2:
```
pm2 start main.js -i max --name nome_server --time --production
```


# **5. Licenza**

## **5.1 Sicurezza lavoro**

Stato Software : Stabile

**Soggetti incaricati del mantenimento del progetto open source**

U.S. s.r.l. 
## **5.2 Indirizzo e-mail segnalazioni di sicurezza**
Ogni segnalazione di eventuali problemi di sicurezza o bug relativo al software presente in questo repository, va segnalato unicamente tramite e-mail agli indirizzi presente nel file security.txt disponibile a questo [link](http://www.gisacampania.it/.well-known/security.txt)

NOTA: Le segnalazioni non vanno inviate attraverso l'issue tracker pubblico ma devono essere inviate confidenzialmente agli indirizzi e-mail presenti nel security.txt.

Lo strumento issue tracker può essere utilizzato per le richieste di modifiche necessarie per implementare nuove funzionalità.

## **5.3 Titolarità: [Regione Campania](http://www.regione.campania.it/)**
Concesso in licenza a norma di: **AGPL versione 3**;

E' possibile utilizzare l'opera unicamente nel rispetto della Licenza.

Una copia della Licenza è disponibile al seguente indirizzo: <https://www.gnu.org/licenses/agpl-3.0.txt>

**NOTE:**

In caso di riuso, in toto o in parte, dell'ecosistema G.I.S.A. Sicurezza e Prevenzione sui luoghi di lavoro, è necessario notificare l'adozione in riuso tramite l'apertura di un ticket (o analogo meccanismo quale una pull request) in questo repository. Inoltre, al contempo per gli aspetti organizzativi utili a potenziare i benefici derivanti dalla pratica del riuso tra PP.AA., come la partecipazione alla **Cabina di regia** per la condivisione di eventuali modifiche/integrazioni o innovazioni, è necessario darne tempestiva comunicazione alle seguenti e-mail:

[paolo.sarnelli@regione.campania.it]() 

[cinzia.matonti@regione.campania.it]()	

Gli enti che aderiscono al riuso di GISA entreranno a far parte della Cabina di Regia per condividere e partecipare all'evoluzione di GISA insieme alle altre PP.AA.