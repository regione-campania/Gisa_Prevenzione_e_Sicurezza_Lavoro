import { Component, Input, OnInit, Output } from '@angular/core';
import { AppService } from 'src/app/app.service';
import {
  ADataDeckFilterConf,
  ADataDeckSorterConf,
} from 'src/app/utils/modules/a-data-deck';
import { SanzioniService } from '../sanzioni.service';
import { ANavigatorService } from 'src/app/utils/modules/a-navigator/a-navigator.service';
import { Utils } from '../../../utils/utils.class';
import { VerbaliService } from 'src/app/verbali/verbali.service';


declare let Swal: any;

@Component({
  selector: 'lista-sanzioni-da-allegare',
  templateUrl: './lista-sanzioni-da-allegare.component.html',
  styleUrls: ['./lista-sanzioni-da-allegare.component.scss'],
})
export class ListaSanzioniDaAllegareComponent implements OnInit {
  @Input() mode: 'creation' | 'linking' = 'creation';
  @Input() fase?: any;
  @Output() stringTooltip?: string;
  @Output() tooltipColor?: string;
  @Output() buttonType?: string;

  sanzioniDaAllegare?: any;

  dataFiltersConf: ADataDeckFilterConf[] = [
    { field: 'codice_avviso', label: 'Codice Avviso', type: 'text' },
    { field: 'proc_pen', label: 'Proc.Pen.', type: 'text' },
    { field: 'rgnr', label: 'RGNR', type: 'text' },
    {
      field: 'data_generazione_iuv',
      label: 'Data Generazione IUV',
      type: 'date',
    },
    {
      field: 'data_notifica',
      label: 'Data notifica',
      type: 'date',
    },
    { field: 'norma', label: 'Norma', type: 'text' },
    { field: 'articolo_violato', label: 'Articolo Violato', type: 'text' },
    {
      field: 'punto_verbale_prescrizione',
      label: 'Punto Verbale Prescrizione',
      type: 'text',
    },
    { field: 'descrizione', label: 'Descrizione', type: 'text' },
    { field: 'n_protocollo', label: 'N. protocollo', type: 'text' },
    { field: 'tipo_verbale', label: 'Tipo verbale', type: 'text' },
    { field: 'tipo_notifica', label: 'Tipo notifica', type: 'text' }
  ];

  dataSortersConf: ADataDeckSorterConf[] = [
    { field: 'codice_avviso', label: 'Codice Avviso', type: 'text' },
    { field: 'proc_pen', label: 'Proc.Pen.', type: 'text' },
    { field: 'rgnr', label: 'RGNR', type: 'text' },
    {
      field: 'data_generazione_iuv',
      label: 'Data Generazione IUV',
      type: 'date',
    },
    {
      field: 'data_notifica',
      label: 'Data Contestazione/Notifica',
      type: 'date',
    },
    { field: 'norma', label: 'Norma', type: 'text' },
    { field: 'articolo_violato', label: 'Articolo Violato', type: 'text' },
    {
      field: 'punto_verbale_prescrizione',
      label: 'Punto Verbale Prescrizione',
      type: 'text',
    },
    { field: 'descrizione', label: 'Descrizione', type: 'text' },
    { field: 'n_protocollo', label: 'N. protocollo', type: 'text' },
    { field: 'tipo_verbale', label: 'Tipo verbale', type: 'text' },
    { field: 'tipo_notifica', label: 'Tipo notifica', type: 'text' }

  ];

  constructor(
    public appService: AppService, 
    private ss: SanzioniService, 
    public navService: ANavigatorService,
    private vs: VerbaliService) {
  }

  ngOnInit(): void {
    if (this.fase) {
      console.log("this.fase:", this.fase);
    }
    if (this.mode == 'creation')
      this.appService.pageName = 'Avvisi di pagamento PagoPA da associare ai verbali';
    Utils.showSpinner(true, 'Caricamento avvisi di pagamento');
    this.ss.getSanzioniDaAllegare().subscribe((res) => {
      this.sanzioniDaAllegare = res;
      console.log("sanzioniDaAllegare:", this.sanzioniDaAllegare);
      Utils.showSpinner(false);
    });
  }

  reloadSanzioniDaAllegare() {
    Utils.showSpinner(true, 'Aggiornamento avvisi di pagamento');
    this.ss.getSanzioniDaAllegare().subscribe((res) => {
      this.sanzioniDaAllegare = res;
      console.log("sanzioniDaAllegare:", this.sanzioniDaAllegare);
      Utils.showSpinner(false);
      this.navService.goBack();
    });
  }

  allegaSanzione(idPagamento: string | number) {
    if (this.fase) {
      Swal.fire({
        titleText: 'L\'Avviso di Pagamento verrà allegato. Confermare?',
        showCancelButton: true,
        confirmButtonText: 'Conferma',
        cancelButtonText: 'Annulla',
        confirmButtonColor: 'var(--blue)',
        cancelButtonColor: 'var(--red)',
      }).then((result: any) => {
        if (result.isConfirmed) {
          this.ss
            .allegaSanzione(this.fase.id_ispezione_fase, idPagamento)
            .subscribe((res) => {
              console.log(res);
              this.reloadSanzioniDaAllegare();
            });
        }
      })
    }
  }

  isSanzioneAnnullabile(stato: any) {
    return !stato.match(/completato/i) && !stato.match(/in.corso/i);
  }

  isSanzionePagata(stato: any){
    return stato.match(/completato/i);
  }

  isSanzioneScaduta(stato: any) {
    if(stato.match(/scadut/i))
      return true;
    else {
      this.stringTooltip = "Modifica data notifica";
      this.tooltipColor = "tooltip tooltip-blue";
      this.buttonType = "btn btn-outline-blue icon-only";
      return false;
    }
  }

  // Controlla che la data di scedenza del cambio non sia ancora arrivata
  isDataScaduta(dataScadenza: any) {
    const deadlineDate = new Date(dataScadenza);
    const today = new Date();
    // Non scaduta
    if (deadlineDate > today) {
      this.stringTooltip = "Modifica data notifica";
      this.tooltipColor = "tooltip tooltip-blue";
      this.buttonType = "btn btn-outline-blue icon-only";
      return false
    }
    // Se è scaduto
    else {
      /*this.stringTooltip = "Avviso di pagamento scaduto";
      this.tooltipColor = "tooltip tooltip-red";
      this.buttonType = "btn btn-outline-red icon-only";*/
      return true
    }
  }

  isNotificaModificabile(stato: any, modalitaContestazione: any, dataScadenza: any) {
    //return this.isSanzioneAnnullabile(stato) && (modalitaContestazione == 'R' || modalitaContestazione == 'P') && (!this.isDataScaduta(dataScadenza)) 
    return this.isSanzioneAnnullabile(stato) && (modalitaContestazione == 'R' || modalitaContestazione == 'P') && (!this.isSanzioneScaduta(stato)) 
  
  }

  annullaPagamento(idPagamento: string | number) {
    Swal.fire({
      titleText: 'L\'avviso di pagamento verrà annullato. Confermare?',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Conferma',
      cancelButtonText: 'Annulla',
      confirmButtonColor: 'var(--blue)',
      cancelButtonColor: 'var(--red)',
    }).then((res: any) => {
      if (res.isConfirmed) {
        this.ss.annullaPagamento(idPagamento).subscribe((res: any) => {
          if (res.esito === 'OK')
            Swal.fire({
              titleText: 'Avviso di pagamento annullato correttamente.',
              icon: 'success',
            }).then(() => this.reloadSanzioniDaAllegare());
          else
            Swal.fire({
              titleText: 'Errore. L\'avviso di pagamento non è stata annullato.',
              icon: 'error',
            });
        });
      }
    });
  }

  modificaDataNotifica(idPagamento: string | number, dataNotifica: any, tipoNotifica: any, dataScadenza: any, dataGenerazione: any, stato: any) {
    //if (this.isDataScaduta(dataScadenza)) return;
    if (this.isSanzioneScaduta(stato)) return;
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
      Data notifica: <input type="date" id="inputDataNotifica" min="${dataGenerazione.slice(0,10)}" value="${dataNotifica}">
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
        if(nuovaDataNotifica < dataGenerazione.slice(0,10)){
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
              this.reloadSanzioniDaAllegare();
            });
          else
            Swal.fire({
              titleText: 'Errore. L\'vviso di pagamento non è stata aggiornato.' + res.codice,
              icon: 'error',
            });
        });
      }
    });
  }

  // Ritorna stringa in base a 'Tipo Notifica'
  getTipoNotificaString(tipoNotifica: string) {
    if (tipoNotifica == 'I') return 'Contestazione Immediata';
    else if (tipoNotifica == 'P') return 'PEC';
    else if (tipoNotifica == 'R') return 'Raccomandata A/R o Consegna a Mano';
    else return undefined;
  }

  // Ritorna data senza orario
  dataWithoutTime(dataPassed: any): Date {
    let _thisData = new Date(dataPassed);
    _thisData.setHours(0, 0, 0, 0);
    return _thisData;
  }

  // Check per il tasto "Associa"
  checkTastoAssocia(tipoNotifica: string, dataFase: Date, dataNotifica: Date): Boolean {
    if (
      tipoNotifica == 'I' && dataFase.valueOf() == dataNotifica.valueOf() ||
      tipoNotifica != 'I' && dataNotifica.valueOf() >= dataFase.valueOf()
    ) return true;
    
    return false;
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

  scaricaRicevuta(idPagamento: number){
    Utils.showSpinner(true, 'Recupero ricevuta RT');
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

}




