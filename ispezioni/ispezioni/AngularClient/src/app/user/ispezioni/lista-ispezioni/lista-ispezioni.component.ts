import { Component, OnInit, TemplateRef, ViewChild } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { AppService } from 'src/app/app.service';
import { ANavigatorService } from 'src/app/utils/modules/a-navigator/a-navigator.service';
import { Utils } from 'src/app/utils/utils.class';
import { Export } from 'src/app/export.class';
import { DettaglioIspezioneComponent } from '../dettaglio-ispezione/dettaglio-ispezione.component';
import { IspezioniService } from '../ispezioni.service';
import { VerbaliService } from '../../../verbali/verbali.service';
import { UserService } from '../../user.service';
import { ASmartTableComponent } from 'src/app/utils/modules/a-smart-table/a-smart-table.component';

declare let Swal: any;

@Component({
  selector: 'lista-ispezioni',
  templateUrl: './lista-ispezioni.component.html',
  styleUrls: ['./lista-ispezioni.component.scss'],
})
export class ListaIspezioniComponent implements OnInit {
  @ViewChild('bodyTemplate') bodyTemplateRef?: TemplateRef<any>;
  @ViewChild('table') tableRef?: ASmartTableComponent;

  ispezioni: any;
  entiDisponibili: any[] = [];
  aslDisponibili: any[] = [];
  ambitiDisponibili: any[] = [];
  motiviDisponibili: any[] = [];
  statiDisponibili: any[] = [];
  esitiDisponibili: any[] = [];
  moduli: any;
  isDirettore: any;
  isRegione: any
  userId: any;

  dettaglioIspezioneModal?: NgbModalRef;
  reopenedDettaglio: boolean = false;

  constructor(
    public is: IspezioniService,
    public vs: VerbaliService,
    private modalEngine: NgbModal,
    private app: AppService,
    private router: Router,
    private route: ActivatedRoute,
    private us: UserService
  ) {
    this.app.pageName = 'Ispezioni';
  }

  ngOnInit(): void {
    this.is.getIspezioni().subscribe((res) => {
      this.route.params.subscribe((p: any) => {
        let ispToReopen = p.reopen;
        console.log(ispToReopen);
        this.ispezioni = res;
        this.ispezioni.forEach((isp: any) => {
          if(isp.id_ispezione == ispToReopen && ! this.reopenedDettaglio){
            window.history.replaceState('', '', '/ispezioni');
            this.openDettaglioIspezione(isp);
            this.reopenedDettaglio = true;
          }
          if (!this.entiDisponibili.includes(isp.descr_ente_isp))
            this.entiDisponibili.push(isp.descr_ente_isp);
          if (!this.aslDisponibili.includes(isp.descr_ente))
            this.aslDisponibili.push(isp.descr_ente);
          if(!isp.ambito)
            isp.ambito = 'Tutti';
          if (!this.ambitiDisponibili.includes(isp.ambito))
            this.ambitiDisponibili.push(isp.ambito);
          if (!this.statiDisponibili.includes(isp.descr_stato_ispezione))
            this.statiDisponibili.push(isp.descr_stato_ispezione);
          if (!this.motiviDisponibili.includes(isp.descr_motivo_isp))
            this.motiviDisponibili.push(isp.descr_motivo_isp);
          if (!this.esitiDisponibili.includes(isp.descr_esito_ispezione))
            this.esitiDisponibili.push(isp.descr_esito_ispezione);
            
        });
      });
      /*this.is.getMotiviIspezione().subscribe((motivi: any) => {
        motivi.forEach((m: any) => {
          this.motiviDisponibili.push(m.descr);
        });
      });*/
      this.is.getModuliVerbale().subscribe((res) => {
        this.moduli = res;
      });

      // Ruolo Utente
      this.isDirettore = false;
      this.isRegione = false;
      this.us.user.subscribe((res: any) => {
        console.log(res);
        this.userId = res.idUtente;
        if (res.ruoloUtente.toUpperCase().includes('DIRETTORE'))
          this.isDirettore = true;
        if (res.ruoloUtente.toUpperCase().includes('REGIONE'))
          this.isRegione = true;
      });
    })
  }

  openDettaglioIspezione(ispezione: any) {
    this.dettaglioIspezioneModal = this.modalEngine.open(
      DettaglioIspezioneComponent,
      {
        centered: true,
        size: 'xl',
        modalDialogClass: 'system-modal',
      }
    );
    this.dettaglioIspezioneModal.componentInstance.ispezione = ispezione;
    this.dettaglioIspezioneModal.componentInstance.editEvent.subscribe(
      (dettaglio: any) => {
        console.log(dettaglio);
        this.dettaglioIspezioneModal?.close();
        this.router.navigate(['ispezione'], {
          relativeTo: this.route,
          queryParams: { id: dettaglio.ispezione.id_ispezione },
        });
      }
    );
    this.dettaglioIspezioneModal.componentInstance.closeEvent.subscribe(() => {
      this.dettaglioIspezioneModal?.close();
      this.ngOnInit();
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
        if (res.isConfirmed)
          this.exportTable(true, (document.querySelector('#idFormato') as HTMLInputElement).value);
      });
    }
  }

  exportTable(full = true, extension?: string | 'xls'): void {
    let table = document.getElementById('tabella-ispezioni')
      ?.firstChild as HTMLTableElement;
    if (!table) throw new Error('No table found.');
    if (full) {
      let temp = document.createElement('table');
      let row: HTMLTableRowElement;
      let cell: HTMLTableCellElement;
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
      this.tableRef?.dm.dataReflex.forEach((reflex) => {
        const data = this.tableRef?.dm.findData(reflex);
        row = body.insertRow();
        for (let p of [
          'descr_ente',
          'ambito',
          'ispettore',
          'codice_ispezione',
          'descr_isp',
          'descr_motivo_isp',
          'cantiere_o_impresa',
          'data_ispezione',
          'descr_stato_ispezione',
          'descr_esito_ispezione',
        ]) {
          cell = row.insertCell();
          cell.innerText = p === 'data_ispezione' ? data[p] ? new Date(data[p]).toLocaleDateString() : '' : data[p];
        }
      });
      table = temp;
    }

    if (extension == 'csv') //se tel o csv uso la libreria
      // se � mobile utilizzo la libreria apposita compatibile con il celulare, altrimenti la nostra custom pi� personalizzata
      Export.tableExportXlsx(table, {
        predicate: (r) =>
          !r.hidden && !r.className.includes('paginator-wrapper'),
          skipColumns: [10]
          // skipColumns: [table.rows!.item(1)!.cells.length - 1],
      },
        extension);
    else // altrimenti uso la tabella html nell xls
      Export.exportTable(table, {
        predicate: (r) =>
          !r.hidden && !r.className.includes('paginator-wrapper'),
          skipColumns: [10]
          // skipColumns: [table.rows!.item(1)!.cells.length - 1],
      });

    /*
    Utils.exportTable(table, {
      predicate: (r) => !r.hidden && !r.className.includes('paginator-wrapper'),
      skipColumns: [8]
    });
    */
  }

  async scaricaModuli(hasIspezione: boolean) {
    {
      console.log(this.moduli);
      var moduliOptions = '';
      const formatiOptions = [
        `<option value="pdf"> PDF </option>`,
        `<option value="doc"> WORD </option>`
      ];
      this.moduli.forEach((mod: any) => {
        moduliOptions += `
          <option value="${mod.id}"> ${mod.descr} </option>`;
      });
      console.log(moduliOptions);

      await Swal.fire({
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
          this.vs.getVerbaleBianco(idModulo, null, null, formato).subscribe((data: any) => {
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
    }
  }

  checkUserID(id_utente_access: string) {
    const splitted = id_utente_access.split(";");
    return splitted.includes(this.userId) ? true : false;
  }
}
