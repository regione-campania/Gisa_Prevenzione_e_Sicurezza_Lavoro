import { Component, EventEmitter, Input, OnDestroy, OnInit, Output } from '@angular/core';
import { Router } from '@angular/router';
import { NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { SanzioniService } from 'src/app/user/sanzioni/sanzioni.service';
import { ANavigatorService } from 'src/app/utils/modules/a-navigator/a-navigator.service';
import { ANavigatorViewDirective } from 'src/app/utils/modules/a-navigator/directives/a-navigator-view.directive';
import { Utils } from 'src/app/utils/utils.class';
import { VerbaliService } from 'src/app/verbali/verbali.service';
import { IspezioniService } from '../ispezioni.service';
import { UserService } from '../../../user/user.service';
import { AnagraficaService } from 'src/app/anagrafica/anagrafica.service';

declare let Swal: any;

@Component({
  selector: 'dettaglio-ispezione',
  templateUrl: './dettaglio-ispezione.component.html',
  styleUrls: ['./dettaglio-ispezione.component.scss'],
})
export class DettaglioIspezioneComponent implements OnInit {
  @Input() modalRef?: NgbModalRef;
  @Output('onClose') closeEvent = new EventEmitter();
  @Output('onEdit') editEvent = new EventEmitter();
  private _ispezione: any;
  dettaglioIspezione: any;
  private _moduliVerbale: any;
  private _gettingInfoSanzione = false;
  private file!: File | null; // Variable to store file
  isFaseChiusa!: boolean;
  isDirettore: any;
  isTheSame: any;

  faseAttiva: any = {};

  verbaleAllegato: any = {};
  altriAllegati: any = [];

  private _moduli: any;
  private _personeCantiere?: any;
  private esitiChiusuraIspezione?: any;

  constructor(
    public is: IspezioniService,
    public vs: VerbaliService,
    public ss: SanzioniService,
    public us: UserService,
    public as: AnagraficaService,
    public navService: ANavigatorService,
    private router: Router,
  ) { }

  ngOnInit(): void {
    console.log("ngOnInit this.faseAttiva:", this.faseAttiva);
    this._moduliVerbale = this.navService.storage.moduliVerbale;
    this.faseAttiva = {}
    this.navService.storage.verbale = {};
    if (!this._moduliVerbale) {
      console.log('--- getting moduli verbale ---');
      this.is.getModuliVerbale().subscribe((res) => {
        this._moduliVerbale = res;
        this.navService.storage.moduliVerbale = this._moduliVerbale;
      });
    }

    // Ruolo Utente
    this.isDirettore = false;
    this.us.user.subscribe((res: any) => {
      if (res.ruoloUtente.toUpperCase().includes('DIRETTORE'))
        this.isDirettore = true;
    });

    this.is.getModuliVerbale().subscribe((res: any) => {
      this._moduli = res;
    });

    this.as.getEsitiChisuraIspezione().subscribe((res: any) => {
      this.esitiChiusuraIspezione = res;
    })

  }

  reload() {
    this.faseAttiva = {};
    this.isTheSame = true;
    this.is
      .getIspezioneInfo(this._ispezione.id_ispezione)
      .subscribe((dettaglio: any) => {
        console.log("dettaglio:", dettaglio);
        this.us.user.subscribe(user => {
          // Modificabile se è l'ispettore che ha creato l'ispezione o il congiunto
          if (dettaglio.ispezione.id_utente_access != user.idUtente && dettaglio.ispezione.id_utente_access_congiunto != user.idUtente)
            this.isTheSame = dettaglio.ispezione.modificabile = false;

          // console.log("this.isTheSame:", this.isTheSame);
          // console.log("dettaglio:", dettaglio);
          // console.log("dettaglioIspezione:", this.dettaglioIspezione);
          // console.log("typeof faseAttiva.verbaleAllegato:", typeof this.faseAttiva.verbaleAllegato);

          this.dettaglioIspezione = dettaglio;

          this.dettaglioIspezione.ispezione.chiudibile = !(this.dettaglioIspezione.fasi.length == 0); //se non ha fasi non si può chiudere

          this.dettaglioIspezione.fasi.forEach((fase: any) => {
            this.ss.getSanzione(fase.id).subscribe((sanz: any) => {
              fase.sanzione = sanz;
            })
            if(!fase.id_modulo) //se almeno una fase non ha il modulo non si può chiudere
              this.dettaglioIspezione.ispezione.chiudibile = false;
          })
          console.log(this.dettaglioIspezione);

          // Recupera le persone legate al cantiere
          if(dettaglio.cantiere.id_cantiere)
            this.is.getPersoneIspezione(dettaglio.cantiere.id_cantiere).subscribe((res: any) => {
              this._personeCantiere = res.filter((persona: any) => {if (persona.codice_fiscale) return persona});
              console.log("this._personeCantiere:", this._personeCantiere);
            })
        })
      });
  }

  modificaIspezione() {
    this.editEvent.emit(this.dettaglioIspezione);
  }

  chiudiIspezione() {
    if(!this.dettaglioIspezione.ispezione.chiudibile) {
      Swal.fire({ text: `Per chiudere l'ispezione devi aggiungere almeno una fase. Per ogni fase inserita deve essere allegato un verbale`, icon: 'warning' });
        return;
    }

    let withAmmenda = false;
    this.dettaglioIspezione.fasi.forEach((fase: any) => {
      if(fase.is_pagopa)
        withAmmenda = true;
    })
    
    var esitiOptions = '<option value="null">Seleziona...</option>';
    this.esitiChiusuraIspezione.forEach((esito: any) => {
      if(esito.iniziale && ((esito.enabled_with_ammenda && withAmmenda) || (!esito.enabled_with_ammenda && !withAmmenda)))
        esitiOptions += `
            <option value="${esito.id}"> ${esito.descr} </option>`;
    });
    console.log(esitiOptions);

    Swal.fire({
      icon: 'info',
      html: `
          <p> Selezionare esito ispezione: </p>
          <select id="esitiIspezione" name="esitiIspezione" style="width: -webkit-fill-available">
            ${esitiOptions}
          </select>
          <br> <br>
          `,
      showCancelButton: true,
      confirmButtonText: 'Chiudi ispezione',
      cancelButtonText: 'Annulla',
      confirmButtonColor: 'var(--blue)',
      cancelButtonColor: 'var(--red)',
    }).then((res: any) => {
      let idEsito = (document.querySelector('#esitiIspezione') as HTMLInputElement).value;
      if (res.isConfirmed && idEsito && idEsito != 'null') {
        this.is.closeIspezione(this.dettaglioIspezione.ispezione.id, parseInt(idEsito)).subscribe((res: any) => {
          this.reload();
        })
      }
    })
  }

  getFaseInfo(idFase: any) {
    console.log("----- getFaseInfo -----");
    delete this.faseAttiva;
    if (!idFase) return;
    this.is.getFaseInfo(idFase).subscribe((res: any) => {
      this.faseAttiva = res;
      this.getSanzioneInfo();
      console.log(res);
      this.isFaseChiusa = false;

      this.verbaleAllegato = {};
      this.altriAllegati = [];

      // Separa Verbale da altri Allegati
      res.verbaleAllegato.forEach((element: { id_modulo: number; }) => {
        if (element.id_modulo != -1 && Object.keys(this.verbaleAllegato).length === 0) { this.verbaleAllegato = element; }
        else if (element.id_modulo == -1) { this.altriAllegati.push(element); }
      });

      console.log("Verbale Allegato:", this.verbaleAllegato);
      console.log("Altri Allegati:", this.altriAllegati);

      if (res.verbaleAllegato.length != 0)
        this.isFaseChiusa = true;
      console.log("Fase chiusa", this.isFaseChiusa);
    });
  }

  reloadFase() {
    this.file = null;
    this.navService.storage.verbale.id_modulo = null;
    this.getSanzioneInfo();
    if (this.faseAttiva.fase) {
      console.log("This.faseAttiva.fase.id_ispezione_fase: " + this.faseAttiva.fase.id_ispezione_fase);
      this.getFaseInfo(this.faseAttiva.fase.id_ispezione_fase);
    }
  }

  deleteFase(idFase: any){
    Swal.fire({
      titleText: 'Eliminare la fase ispezione?',
      showCancelButton: true,
      confirmButtonText: 'Conferma',
      cancelButtonText: 'Annulla',
      confirmButtonColor: 'var(--blue)',
      cancelButtonColor: 'var(--red)',
    }).then((result: any) => {
      if (result.isConfirmed) {
        this.is.deleteFase(idFase).subscribe((res:any) => {
          this.reload();
        })
      }
    })
  }

  insertFase(fase: any) {
    this.is.updateFaseInfo(fase).subscribe((res: any) => {
      if (!res.esito) {
        Swal.fire({ text: res.msg.split(' [')[0], icon: 'warning' });
        return;
      }
      this.navService.goBack();
      this.reload();
      this.getFaseInfo(res.valore);
    });
  }

  modificaVerbale(verbale: any) {
    console.log(verbale);
    this.navService.storage.verbale = verbale;
    this.navService.changeView('Fase');
  }

  eliminaVerbale(verbale: any) {
    this.vs.deleteVerbale(verbale.id_verbale).subscribe((res: any) => {
      if (res.esito) this.reloadFase();
    });
  }

  // CURRENTLY
  eliminaVerbaleBianco(idAllegato: any, is_allegato?: boolean) {
    console.log("idAllegato:", idAllegato);

    const idModulo = [-1, this.verbaleAllegato.id_modulo];

    // console.log("id_modulo: " + this.faseAttiva.verbaleAllegato.id_modulo);
    console.log("id_ispezione_fase: " + this.faseAttiva.fase.id_ispezione_fase);
    let title = 'Eliminare verbale?';
    if(is_allegato)
      title = 'Eliminare allegato?';
    Swal.fire({
      titleText: title,
      showCancelButton: true,
      confirmButtonText: 'Conferma',
      cancelButtonText: 'Annulla',
      confirmButtonColor: 'var(--blue)',
      cancelButtonColor: 'var(--red)',
    }).then((result: any) => {
      if (result.isConfirmed) {
        this.vs.deleteVerbaleBianco(idModulo, this.faseAttiva.fase.id_ispezione_fase, idAllegato).subscribe((res: any) => {
          console.log("res.esito: " + res.esito);
          if (res.esito) this.reloadFase();
        });
      }
    })
  }

  allegaVerbaleCompleto(event: any) {
    this.file = event.target.files[0];
  }

  uploadVerbaleCompleto(verbale: any) {
    console.log(this.file)
    this.vs.allegaVerbaleCompleto(this.file!, verbale.id_verbale).subscribe((res: any) => {
      console.log(res);
      if (res.esito) {
        Swal.fire({
          text: 'Verbale allegato correttamente!',
          icon: 'success',
        });
        this.reloadFase();
      }
    });
  }

  uploadVerbaleBiancoCompleto() {
    const modulo = this._moduliVerbale.find((x: any) => x.id === this.navService.storage.verbale.id_modulo);
    console.log("modulo:", modulo);
    console.log("this.faseAttiva.avvisiPagamento.length:", this.faseAttiva.avvisiPagamento.length);
    console.log("this.faseAttiva.verbaleAllegato:", this.faseAttiva.verbaleAllegato);
    console.log(this.navService.storage.verbale.id_modulo);
    console.log(this.faseAttiva.fase.id_ispezione_fase);
    console.log(this.file);
    if (!this.navService.storage.verbale.id_modulo && !this.isFaseChiusa) {
      Swal.fire({
        text: 'Selezionare tipo verbale da allegare',
        icon: 'info',
      });
      return;
    }
    if (!this.file) {
      Swal.fire({
        text: 'Selezionare file da allegare',
        icon: 'info',
      });
      return;
    }

    if(modulo && this.faseAttiva.fase.id_modulo_avviso_di_pagamento && modulo.id != this.faseAttiva.fase.id_modulo_avviso_di_pagamento) {
      Swal.fire({
        icon: `warning`,
        text: `L'avviso di pagamento aggiunto è stato creato per il tipo verbale '${this.faseAttiva.fase.descr_modulo_avviso_di_pagamento}'. 
        Stai provando invece ad allegare un '${modulo.descr}'`
      });
      return;
    }

    if(modulo && modulo.is_pagopa && this.faseAttiva.avvisiPagamento.length == 0){
      Swal.fire({
        icon: `warning`,
        text: `Questo modulo prevede un avviso di pagamento. Associa un Avviso di Pagamento prima di allegare il verbale.`
      });
      return;
    }

    if (this.faseAttiva.avvisiPagamento.length > 0 && modulo != undefined && modulo.is_pagopa == false) {
      Swal.fire({
        icon: `warning`,
        text: `Questo modulo non prevede avvisi di pagamento. Disassociare Avviso di Pagamento Associato.`
      });
      return;
    }

    let innerIDModulo;
    let myText: string;

    if (this.isFaseChiusa) {
      innerIDModulo = -1;
      myText = 'Documento allegato correttamente';
    } else {
      myText = 'Verbale allegato correttamente!';
      innerIDModulo = this.navService.storage.verbale.id_modulo;
    }

    Utils.showSpinner(true, "Caricamento allegato in corso");
    this.vs.allegaVerbaleBiancoCompleto(this.file, innerIDModulo, this.faseAttiva.fase.id_ispezione_fase).subscribe((res: any) => {
      Utils.showSpinner(false);
      console.log(res);
      if (res.esito) {
        Swal.fire({
          text: myText,
          icon: 'success',
        });
        this.reloadFase();
      }
    });
  }

  scaricaVerbale(verbale: any) {
    if (verbale != undefined) {
      Utils.showSpinner(true);
      this.vs.getJsonVerbale(verbale.id_verbale).subscribe((json) => {
        let dataToSend = json;
        console.log(this.ispezione);
        console.log(verbale);
        this.vs.downloadVerbale(dataToSend, this.faseAttiva.fase.id).subscribe({
          next: (data) => {
            Utils.download(data, `${verbale.descr_modulo}.pdf`);
            Utils.showSpinner(false);
          },
          error: (err) => {
            Swal.fire({
              text: 'Errore nella generazione del PDF!',
              icon: 'error',
            });
            Utils.showSpinner(false);
            console.error(err);
          },
        });
      });
    }
  }

  scaricaVerbaleBiancoCompilato(idAllegato: any) {
    if (this.faseAttiva?.fase.id_ispezione_fase != undefined) {
      Utils.showSpinner(true);
      // console.log("id_modulo: " + this.faseAttiva.verbaleAllegato.id_modulo);
      console.log("id_ispezione_fase: " + this.faseAttiva.fase.id_ispezione_fase);

      console.log("idAllegato:", idAllegato);
      const idModulo = idAllegato != null ? -1 : this.verbaleAllegato.id_modulo;

      this.vs.downloadVerbaleBiancoCompilato(idModulo, this.faseAttiva.fase.id_ispezione_fase, idAllegato).subscribe((data: any) => {
        try {
          console.log(data)
          console.log("Content-Disposition: " + data.headers.get('content-disposition'));
          Utils.download(data.body, `${data.headers.get('content-disposition').split('filename="')[1].replaceAll('"', '')}`)
        } catch (e) {
          Swal.fire({
            text: 'Errore nella generazione del template!',
            icon: 'error',
          });
        } finally {
          Utils.showSpinner(false);
        }
      })
    };
  }

  scaricaVerbaleBianco(): void {
    console.log(this._moduli);
    
    var moduliOptions = '';
    const formatiOptions = [
      `<option value="pdf"> PDF </option>`,
      `<option value="doc"> WORD </option>`
    ];
    this._moduli.forEach((mod: any) => {
      moduliOptions += `
          <option value="${mod.id}"> ${mod.descr} </option>`;
    });
    console.log(moduliOptions);

    Swal.fire({
      icon: 'info',
      html: `
          <p> Selezionare template da esportare: </p>
          <select id="moduli" name="moduli" style="width: -webkit-fill-available">
            ${moduliOptions}
          </select>
          <br> <br>
          <p> Seleziona il formato da esportare </p>
          <select id="idFormato" name="formati" style="width: 100px">
            ${formatiOptions}
          </select>
          `,
      showCancelButton: true,
      confirmButtonText: 'Scarica',
      cancelButtonText: 'Annulla',
      confirmButtonColor: 'var(--blue)',
      cancelButtonColor: 'var(--red)',
    }).then((res: any) => {
      let idModulo = parseInt((document.querySelector('#moduli') as HTMLInputElement).value);
      const formato = (document.querySelector('#idFormato') as HTMLInputElement).value;
      console.log("formato scelto:", formato);
      if (res.isConfirmed && idModulo) {          //alert(value);
        Utils.showSpinner(true, 'Generazione template in corso');
        this.vs.getVerbaleBianco(idModulo, this.faseAttiva.fase != null ? this.faseAttiva.fase.id_ispezione_fase : null, this.dettaglioIspezione.ispezione.id, formato).subscribe((data: any) => {
          try {
            console.log(data);
            console.log(
              'Content-Disposition: ' +
              data.headers.get('content-disposition')
            );
            Utils.download(
              data.body,
              `${data.headers
                .get('content-disposition')
                .split('filename="')[1]
                .replaceAll('"', '')}`
            );
          } catch (err) {
            Swal.fire({
              text: 'Errore nella generazione del template!',
              icon: 'error',
            });
            console.error(err);
          } finally {
            Utils.showSpinner(false);
          }
        });
      }
    });

    /*
    // Controlla che l'id del modulo esista e che sia diverso da null
    if (idModulo == null || idModulo == "null") {
      Swal.fire({
        text: 'Selezionare il modulo',
        icon: 'info',
      });
      return;
    } else {
      const formatiOptions = [
        `<option value="pdf"> PDF </option>`,
        `<option value="doc"> WORD </option>`
      ];
      Swal.fire({
        icon: `info`,
        html: `
          <p> Seleziona il formato da esportare </p>
          <select id="idFormato" name="formati" style="width: 100px">
            ${formatiOptions}
          </select>
        `,
        showCancelButton: true,
        confirmButtonText: 'Scarica',
        cancelButtonText: 'Annulla',
        confirmButtonColor: 'var(--blue)',
        cancelButtonColor: 'var(--red)',
      }).then((res: any) => {
        if (res.isConfirmed && idModulo) {
          Utils.showSpinner(true, 'Generazione modulo in corso');
          const formato = (document.querySelector('#idFormato') as HTMLInputElement).value;
          console.log("formato scelto:", formato);
          this.vs.getVerbaleBianco(idModulo, this.faseAttiva?.fase.id_ispezione_fase, formato).subscribe((data: any) => {
            try {
              console.log(data)
              console.log("Content-Disposition: " + data.headers.get('content-disposition'));
              Utils.download(data.body, `${data.headers.get('content-disposition').split('filename="')[1].replaceAll('"', '')}`)
            } catch (err) {
              Swal.fire({
                text: 'Errore nella generazione del modulo!',
                icon: 'error',
              });
              console.error(err);
            } finally {
              Utils.showSpinner(false);
            }
          });
        }
      })
    }
    */
  }

  getSanzioneInfo() {
    if (Object.keys(this.faseAttiva).length === 0) return;
    this.faseAttiva.avvisiPagamento = [];
    this._gettingInfoSanzione = true;
    this.ss
      .getSanzione(this.faseAttiva?.fase.id_ispezione_fase)
      .subscribe((res: any) => {
        this.faseAttiva.avvisiPagamento = res;
        this._gettingInfoSanzione = false;
      });
  }

  annullaPagamento(idPagamento: any) {
    Swal.fire({
      title: 'Sei sicuro di voler rimuovere l\' avviso di pagamento?',
      icon: 'warning',
      showDenyButton: true,
      confirmButtonText: 'Si',
      customClass: {
        confimButton: 'btn btn-outline-blue',
        denyButton: 'btn btn-outline-red',
      },
    }).then((res: any) => {
      if (res.isConfirmed) {
        this.ss
          .annullaPagamento(idPagamento)
          .subscribe(() =>
            this.getFaseInfo(this.faseAttiva?.fase.id_ispezione_fase)
          );
      }
    });
  }

  // Disassocia avviso di pagamento ma senza eliminarlo
  disassociaPagamento(idPagamento: any) {
    Swal.fire({
      title: 'Sei sicuro di voler disassociare l\' avviso di pagamento?',
      icon: 'warning',
      showDenyButton: true,
      confirmButtonText: 'Si',
      customClass: {
        confimButton: 'btn btn-outline-blue',
        denyButton: 'btn btn-outline-red',
      },
    }).then((res: any) => {
      if (res.isConfirmed) {
        console.log("idPagamento:", idPagamento);
        // Richiama servizio "DisassociaAvviso"
        this.ss.allegaSanzione(-1, idPagamento).subscribe((res: any) => {
          // Svuota gli avvisi di Pagamento e ricarica
          this.faseAttiva.avvisiPagamento = [];
          this.reloadFase();
        })
      }
    });
  }

  annullaSanzione() {
    Swal.fire({
      title: 'Sei sicuro di voler rimuovere gli avvisi di pagamento?',
      icon: 'warning',
      showDenyButton: true,
      confirmButtonText: 'Si',
      customClass: {
        confimButton: 'btn btn-outline-blue',
        denyButton: 'btn btn-outline-red',
      },
    }).then((res: any) => {
      if (res.isConfirmed) {
        this.ss
          .annullaSanzione(this.faseAttiva.fase.id_ispezione_fase)
          .subscribe(() =>
            this.getFaseInfo(this.faseAttiva?.fase.id_ispezione_fase)
          );
      }
    });
  }

  isDataScaduta(dataScadenza: any) {
    const deadlineDate = new Date(dataScadenza);
    const today = new Date();
    // Non scaduta
    if (deadlineDate > today) {
      return false
    }
    // Se è scaduto
    else {
      return true
    }
  }

  modificaDataNotifica(idPagamento: string | number, dataNotifica: any, tipoNotifica: any, dataScadenza: any, dataGenerazione: any) {
    if (this.isDataScaduta(dataScadenza)) {
      Swal.fire({
        titleText: 'Non è possibile aggiornata la data contestazone/notifica in quanto l\'avviso di pagamento è scaduto',
        icon: 'error',
      })
      return;
    }
    let opposite = undefined;
    const currentNotifica = tipoNotifica;

    if (tipoNotifica == 'P') {
      tipoNotifica = 'PEC';
      opposite = "Raccomandata A/R o consegna a mano";
    }
    else if (tipoNotifica == 'R') {
      tipoNotifica = 'Raccomandata A/R o consegna a mano';
      opposite = "PEC";
    }

    Swal.fire({
      icon: 'info',
      html: `
      <p> Tipo Notifica: </p>
      <select id="notifica" name="notifica">
        <option value=0> ${tipoNotifica} </option>
        <option value=1> ${opposite} </option>
      </select>
      <br><br>
      <p> Inserisci nuova data contestazione immediata/notifica </p>
      Data notifica: <input type="date" id="inputDataNotifica" min="${dataGenerazione.slice(0, 10)}" value="${dataNotifica}">
      <br>
      <small>La data scadenza sarà impostata a 30 giorni dalla nuova data di contestazione immediata/notifica</small>
      `,
      showCancelButton: true,
      confirmButtonText: 'Conferma',
      cancelButtonText: 'Annulla',
      confirmButtonColor: 'var(--blue)',
      cancelButtonColor: 'var(--red)',
    }).then((res: any) => {
      let nuovaDataNotifica = (document.querySelector("#inputDataNotifica") as HTMLInputElement).value;
      let changeNotifica = true ? parseInt((document.querySelector('#notifica') as HTMLInputElement).value) == 1 : false;
      if (res.isConfirmed && nuovaDataNotifica) {
        if (nuovaDataNotifica < dataGenerazione.slice(0, 10)) {
          Swal.fire({
            titleText: 'Attenzione! La data contestazione/notifica non può essere inferiore alla di generazione IUV!".',
            icon: 'error',
          })
          return;
        }
        Utils.showSpinner(true);
        this.ss.modificaDataNotifica(idPagamento, nuovaDataNotifica, currentNotifica, changeNotifica).subscribe((res: any) => {
          if (res.esito === 'OK')
            Swal.fire({
              titleText: 'Data notifica aggiornata correttamente.',
              icon: 'success',
            }).then(() => {
              Utils.showSpinner(true);
              this.reloadFase();
              Utils.showSpinner(false);
            });
          else
            Swal.fire({
              titleText: 'Errore. L\'Avviso di Pagamento non è stata aggiornato.' + res.codice,
              icon: 'error',
            });
        });
      }
    });
  }

  scaricaRicevutaRT(idPagamento: number){
    Utils.showSpinner(true, 'Recupero ricevuta RT in corso');
    this.vs.scaricaRicevutaRT(idPagamento).subscribe((data: any) => {
      try {
        console.log(data)
        console.log("Content-Disposition: " + data.headers.get('content-disposition'));
        Utils.download(data.body, `${data.headers.get('content-disposition').split('filename="')[1].replaceAll('"', '')}`)
      } catch (e) {
        Swal.fire({
          text: 'Errore nella generazione del template!',
          icon: 'error',
        });
      } finally {
        Utils.showSpinner(false);
      }
    })
  }

  scaricaAvviso(idPagamento: number){
    Utils.showSpinner(true, 'Recupero avviso di pagamento');
    this.vs.scaricaAvviso(idPagamento).subscribe((data: any) => {
      try {
        console.log(data)
        console.log("Content-Disposition: " + data.headers.get('content-disposition'));
        Utils.download(data.body, `${data.headers.get('content-disposition').split('filename="')[1].replaceAll('"', '')}`)
      } catch (e) {
        Swal.fire({
          text: 'Errore nella generazione del template!',
          icon: 'error',
        });
      } finally {
        Utils.showSpinner(false);
      }
    })
  }

  onNavigatorViewChange(view: ANavigatorViewDirective) {
    // this.getSanzioneInfo();
    if (view.viewName === 'Fase') {
      this.reloadFase();
    }
  }

  //accessors
  @Input()
  get ispezione() {
    return this._ispezione;
  }

  set ispezione(value) {
    this._ispezione = value;
    this.reload();
  }

  get moduliVerbale() {
    return this._moduliVerbale;
  }

  /*  get faseAttiva() {
     return this.faseAttiva;
   } */

  get gettingInfoSanzione() {
    return this._gettingInfoSanzione;
  }

  get isSanzioneAnnullabile() {
    return !this.avvisoPagamentoInCorso && !this.avvisoPagamentoPagato;
  }

  get avvisoPagamentoPagato() {
    return this.faseAttiva.avvisiPagamento?.find(
      (x: any) => x && x.stato_pagamento.match(/completato/i)
    );
  }

  get avvisoPagamentoInCorso() {
    return this.faseAttiva.avvisiPagamento?.find(
      (x: any) => x && x.stato_pagamento.match(/in.corso/i)
    );
  }

  public get moduli() {
    return this._moduli;
  }

  public get personeCantiere() {
    return this._personeCantiere;
  }

}
