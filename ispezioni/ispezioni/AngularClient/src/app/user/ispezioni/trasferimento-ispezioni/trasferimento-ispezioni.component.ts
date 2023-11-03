import { Component, OnInit, Input } from '@angular/core';
import { IspezioniService } from '../ispezioni.service';
import { Utils } from 'src/app/utils/utils.class';
import { AppService } from 'src/app/app.service';
import {
  ADataDeckFilterConf,
  ADataDeckSorterConf,
} from 'src/app/utils/modules/a-data-deck';
import { elementAt } from 'rxjs';
declare let Swal: any;

@Component({
  selector: 'app-trasferimento-ispezioni',
  templateUrl: './trasferimento-ispezioni.component.html',
  styleUrls: ['./trasferimento-ispezioni.component.scss']
})
export class TrasferimentoIspezioniComponent implements OnInit {
  @Input() mode: 'creation' | 'linking' = 'creation';
  ispettori: any;
  ispezioniOriginal?: any;
  ispezioni?: any;
  private selectedItemsList: any = [];
  selectedFrom = "";
  selectedTo = "";
  tipiFiltrabili: any[] = [];
  motiviFiltrabili: any[] = [];

  dataFiltersConf: ADataDeckFilterConf[] = [
    { field: 'codice_ispezione', label: 'CUI', type: 'text' },
    { field: 'descr', label: 'Descrizione', type: 'text' },
    { field: 'descr_motivo_isp', label: 'Motivo', type: 'selection', values: this.motiviFiltrabili },
    { field: 'cantiere_o_impresa', label: 'Tipo', type: 'selection', values: this.tipiFiltrabili  },
    { field: 'data', label: 'Data', type: 'date' },
  ];

  dataSortersConf: ADataDeckSorterConf[] = [
    { field: 'codice_ispezione', label: 'CUI', type: 'text' },
    { field: 'descr', label: 'Descrizione', type: 'text' },
    { field: 'descr_motivo_isp', label: 'Motivo', type: 'text' },
    { field: 'cantiere_o_impresa', label: 'Tipo', type: 'text'},
    { field: 'data', label: 'Data', type: 'text' },
  ];

  constructor(
    public appService: AppService,
    public is: IspezioniService,
  ) { }

  ngOnInit(): void {
    this.is.getIspettoriServizio().subscribe((res) => {
      this.ispettori = res;
    });
  }

  // Prendi le ispezioni in base all'id dell'ispettore
  getIspezioni(idIspettore: any): void {
    console.log(idIspettore);
    this.is.getIspezioniByIdIspettore(idIspettore).subscribe((res: any) => {
      console.log(res);
      this.ispezioniOriginal = res;
      this.ispezioni = this.ispezioniOriginal.filter((isp: any) => isp.id_utente_access_congiunto != this.selectedTo);
      console.log("this.ispezioni:", this.ispezioni);
      this.ispezioni.forEach((isp: any) => {
        if(!this.tipiFiltrabili?.includes(isp.cantiere_o_impresa))
          this.tipiFiltrabili.push(isp.cantiere_o_impresa)
        if(!this.motiviFiltrabili?.includes(isp.descr_motivo_isp))
          this.motiviFiltrabili.push(isp.descr_motivo_isp)
      })
    });
  }

  // Invia le ispezioni dell'ispettore preso in input all'altro
  inviaTrasferimento(): void {
    if(this.selectedFrom == 'null')
      this.selectedFrom = "";
    if(this.selectedTo == 'null')
      this.selectedTo = "";

    // Controlla selezione ispettori
    if (!this.selectedFrom || !this.selectedTo) {
      Swal.fire({
        text: "Attenzione! Accettarsi di aver selezionato entrambi gli ispettori.",
        icon: "error",
      });
    }
    // Controllo selezione stesso ispettore
    else if (this.selectedFrom == this.selectedTo) {
      Swal.fire({
        text: "Attenzione! Hai selezionato lo stesso ispettore.",
        icon: "error",
      })
    }
    // Controllo checkboxes vuoti
    else if (this.selectedItemsList.length == 0) {
      Swal.fire({
        text: "Attenzione! Non hai selezionato nessuna ispezione da trasferire.",
        icon: "error",
      })
    }
    // Nessun errore di selezione
    else {
      Utils.showSpinner(true);
      this.is.trasferisciIspezioni(this.selectedFrom, this.selectedTo, this.selectedItemsList).subscribe({
        complete: () => {
          Swal.fire({
            text: 'Trasferimento avvenuto con successo',
            icon: 'success',
          })
          this.getIspezioni(this.selectedFrom);

          // Svuota la lista dei checkboxes selezionati
          this.selectedItemsList = [];
        },
        error: (err) => {
          Swal.fire({
            text: 'Errore trasferimento ispezioni!',
            icon: 'error',
          })
          console.log(err);
        }
      });
      Utils.showSpinner(false);
    }
  }

  // Controlla se l'elemento selezionato è incluso nell'array
  onCheck(evt: any): void {
    if (!this.selectedItemsList.includes(evt))
      this.selectedItemsList.push(evt);
    else {
      var index = this.selectedItemsList.indexOf(evt);
      if (index > -1)
        this.selectedItemsList.splice(index, 1);
    }

    console.log(this.selectedItemsList);
  }

  // Seleziona tutti gli elementi
  checkAll(evt: any): void {
    for (var key in this.ispezioni){
      if (!this.selectedItemsList.includes(this.ispezioni[key].id))
        this.selectedItemsList.push(this.ispezioni[key].id);
    }

    this.checkCheckboxes(true);

    console.log(this.selectedItemsList.length);
    console.log(this.selectedItemsList);
  }

  // Deseleziona tutti gli elementi
  uncheckAll(evt: any): void {
    this.selectedItemsList = [];

    this.checkCheckboxes(false);

    console.log(this.selectedItemsList.length);
    console.log(this.selectedItemsList);
  }

  // Seleziona o Deseleziona graficamente gli elementi
  private checkCheckboxes(thisChecked: boolean): void {
    const checkboxes = document.querySelectorAll('input[type=checkbox]');
    Array.from(checkboxes).forEach(elem => {
      Object.values(elem)[0][0].target.checked = thisChecked;
    });
  }

  selectedFromChangeHandler(event: any) {
    this.selectedItemsList = [];
    this.selectedFrom = event.target.value;
    console.log("this.selectedFrom:", this.selectedFrom);
  }

  selectedToChangeHandler(event: any) {
    this.selectedItemsList = [];
    this.selectedTo = event.target.value;
    console.log("this.selectedTo:", this.selectedTo);
    this.ispezioni = this.ispezioniOriginal.filter((isp: any) => isp.id_utente_access_congiunto != this.selectedTo);
  }
}
