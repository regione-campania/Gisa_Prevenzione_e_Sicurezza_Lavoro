import {
  Component,
  DoCheck,
  OnChanges,
  OnInit,
  SimpleChanges,
  ViewChild,
} from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Utils } from 'src/app/utils/utils.class';
import { AnagraficaService } from 'src/app/anagrafica/anagrafica.service';
import {
  ADataDeckFilterConf,
  ADataDeckSorterConf,
} from 'src/app/utils/modules/a-data-deck';
import { AppService } from 'src/app/app.service';
import { NotificheService } from '../notifiche.service';
import { UserService } from 'src/app/user/user.service';
import { Export } from 'src/app/export.class';
declare let Swal: any;

@Component({
  selector: 'lista-notifiche',
  templateUrl: './lista-notifiche.component.html',
  styleUrls: ['./lista-notifiche.component.scss'],
})
export class ListaNotificheComponent implements OnInit, DoCheck {
  @ViewChild('table') tableRef: any;

  userNotices?: any[];
  statiDisponibili: any[] = [];
  anniDisponibili: any[] = [];
  aslDisponibili: any[] = [];
  role?: any; //ruolo utente

  dataFiltersConf: ADataDeckFilterConf[] = [];
  dataSortersConf: ADataDeckSorterConf[] = [];

  constructor(
    private us: UserService,
    private ns: NotificheService,
    private router: Router,
    private route: ActivatedRoute,
    public appService: AppService,
    public anagraficaService: AnagraficaService
  ) {
    this.appService.pageName = 'Notifiche preliminari';
  }

  ngOnInit(): void {
    /* this.role = this.us.userRole; */
    this.us.user.subscribe((res) => {
      this.role = res.ruoloUtente;
    })
    Utils.showSpinner(
      true,
      'Caricamento notifiche in corso. Si prega di attendere'
    );
    this.ns.getNotifiche().subscribe((notices) => {
       /* this.anagraficaService.getStatiNotifica().subscribe((s: any) => {
        s.map((a: any) => a.descr).forEach((el: any) => {
          this.statiDisponibili?.push(el);
        });
        this.statiDisponibili.sort((a: any, b: any) => a.localeCompare(b));
        console.log(this.statiDisponibili)
      });
      this.aslDisponibili = [];*/
      notices.forEach((n: any) => {
        if (!this.statiDisponibili?.includes(n.stato))
          this.statiDisponibili?.push(n.stato);
        if (!this.anniDisponibili?.includes(n.anno))
          this.anniDisponibili?.push(n.anno);
        if (!this.aslDisponibili?.includes(n.descr_asl) && n.descr_asl)
          this.aslDisponibili?.push(n.descr_asl);
      });
      this.aslDisponibili?.sort((a: any, b: any) => a.localeCompare(b));
      console.log(notices);
      this.userNotices = notices;
      Utils.showSpinner(false);
      this.initDataFiltersConf();
      this.initDataSortersConf();
    });
  }

  ngDoCheck(): void {
    if (this._exporting)
      if (document.getElementById('tabella-notifiche')) this.exportTable();
  }

  goToNoticeEditor(noticeId: number, mode: any, modeCantiere: any) {
    this.router.navigate(['notifica'], {
      relativeTo: this.route,
      queryParams: {
        idNotifica: noticeId,
        mode: mode,
        modeCantiere: modeCantiere,
      },
    });
  }

  insertNotifica() {
    this.ns.insertNotifica().subscribe((res) => {
      if (res.esito) {
        this.goToNoticeEditor(res.valore, true, null);
      } else {
        Swal.fire({ text: res.msg.split(' [')[0], icon: 'error' });
      }
    });
  }


  async chooseExport() {
    {
      const formatiOptions = [
        `<option value="xls"> EXCEL </option>`,
        `<option value="csv"> CSV </option>`
      ];

      await Swal.fire({
        icon: 'info',
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
        if(res.isConfirmed)
          this.exportTable(true ,(document.querySelector('#idFormato') as HTMLInputElement).value);
      });
    }
  }

  private _exporting = false;

  exportTable(full = true, extension?: string | 'xls'): void {
    console.log(this.userNotices?.length);
    //enable export in mobile view
    if (this.userNotices?.length == 0) {
      Swal.fire({
        text: 'Non sono presenti notifiche da esportare',
        icon: 'warning',
      });
      return;
    }

    if (this.appService.isMobileView) {
      this.appService.isMobileView = false;
      this._exporting = true;
      return;
    }
    let table = document.getElementById('tabella-notifiche')
      ?.firstChild as HTMLTableElement;
    if (!table) throw 'No table found.';
    if (full) {
      let temp = document.createElement('table');
      let row: HTMLTableRowElement, cell: HTMLTableCellElement;
      let head = temp.createTHead();
      Array.from(table.tHead!.rows).forEach((r) => {
        if(r.getAttribute('class')?.includes('paginator-row'))
          return;
        row = head.insertRow();
        Array.from(r.cells!).forEach((c) => {
          cell = row.insertCell();
          cell.innerText = c.innerText;
        });
      });
      let body = temp.createTBody();
      //dataReflex shape: {p: number, v: boolean}
      this.tableRef?.dm.dataReflex.forEach((c: any) => {
        if (!c.visible) return;
        let n = this.tableRef?.data[c.pointer];
        row = body.insertRow();
        let columns = [
          'cun',
          'cuc',
          'denominazione',
          'anno',
          'data_modifica',
          'descr_asl',
          'stato',
          'via',
          'civico',
          'comune',
          'cap',
          'natura_opera',
          'altra_natura_opera',
          'data_presunta',
          'durata_presunta',
          'numero_imprese',
          'numero_lavoratori',
          'ammontare',
          'lavori_edili',
          'imprese',
        ];
        if (this.role == 'Profilo Notificatore'){
          columns = [
            'cun',
            'cuc',
            'denominazione',
            'data_modifica',
            'stato',
            'via',
            'civico',
            'comune',
            'cap',
            'natura_opera',
            'altra_natura_opera',
            'data_presunta',
            'durata_presunta',
            'numero_imprese',
            'numero_lavoratori',
            'ammontare',
            'lavori_edili',
            'imprese',
          ];
        }
        if(this.role != 'Profilo Regione'){ //la regione non vede le persone
          if(this.role != 'Profilo Notificatore') //il notificatore non vede se stesso
            columns.unshift('cognome_notificante');
          columns.push('committenti');
          columns.push('responsabile');
          columns.push('coord_progettazione');
          columns.push('coord_realizzazione');
        }
        for (let p of columns) {
          cell = row.insertCell();
          switch(p) {
            case 'cognome_notificante': cell.innerText = `${n['cognome_notificante']} ${n['nome_notificante']}`; break;
            case 'data_modifica': cell.innerText = n[p] ? new Date(n[p]).toLocaleDateString() : ''; break;
            case 'lavori_edili': n[p] ? cell.innerText = 'SI' : cell.innerText = 'NO'; break;
            default: cell.innerText = n[p]; break;
          }
        }
      });
      table = temp;
    }
    let _skipColumns = [25];
    if(this.role == 'Profilo Regione'){
      _skipColumns.push(24);
      _skipColumns.push(23);
      _skipColumns.push(22);
      _skipColumns.push(21);
      _skipColumns.push(20);
    }
    if (window.innerWidth < 992 || extension == 'csv') //se tel o csv uso la libreria
      // se � mobile utilizzo la libreria apposita compatibile con il celulare, altrimenti la nostra custom pi� personalizzata
      Export.tableExportXlsx(table, {
        predicate: (r) =>
          !r.hidden && !r.className.includes('paginator-wrapper'),
          skipColumns: _skipColumns,
       // skipColumns: [table.rows!.item(1)!.cells.length - 1],
      },
      extension);
    else // altrimenti uso la tabella html nell xls
      Export.exportTable(table, {
        predicate: (r) =>
          !r.hidden && !r.className.includes('paginator-wrapper'),
          skipColumns: _skipColumns
       // skipColumns: [table.rows!.item(1)!.cells.length - 1],
      });

    this.appService.isMobileView = window.innerWidth < 992;
    this._exporting = false;
  }

  initDataFiltersConf() {
    //building filters config
    if (this.role != 'Profilo Notificatore' && this.role != 'Profilo Regione') {
      this.dataFiltersConf.push(
        {
          field: 'nome_notificante | cognome_notificante',
          type: 'text',
          label: 'Notificante',
        },
        {
          field: 'anno',
          type: 'selection',
          label: 'Anno notifica',
          values: this.anniDisponibili,
        },
        {
          field: 'descr_asl',
          type: 'selection',
          label: 'ASL',
          values: this.aslDisponibili,
        }
      );
    }
    this.dataFiltersConf.push(
      { field: 'cun', type: 'text', label: 'Cun' },
      { field: 'cuc', type: 'text', label: 'Cuc' },
      { field: 'denominazione', type: 'text', label: 'Denominazione' },
      { field: 'data_modifica', type: 'date', label: 'Ultima modifica' },
      {
        field: 'stato',
        type: 'selection',
        label: 'Stato',
        values: this.statiDisponibili,
      }
    );
  }

  initDataSortersConf() {
    //building sorters config
    if (this.role != 'Profilo Notificatore') {
      this.dataSortersConf.push(
        { field: 'nome_notificante', type: 'text', label: 'Nome Notificante' },
        {
          field: 'cognome_notificante',
          type: 'text',
          label: 'Cognome Notificante',
        },
        { field: 'anno', type: 'date', label: 'Anno notifica' },
        { field: 'descr_asl', type: 'text', label: 'ASL' }
      );
    }
    this.dataSortersConf.push(
      { field: 'cun', type: 'text', label: 'Cun' },
      { field: 'cuc', type: 'text', label: 'Cuc' },
      { field: 'denominazione', type: 'text', label: 'Denominazione' },
      { field: 'data_modifica', type: 'date', label: 'Ultima modifica' },
      { field: 'stato', type: 'text', label: 'Stato' }
    );
  }
}
