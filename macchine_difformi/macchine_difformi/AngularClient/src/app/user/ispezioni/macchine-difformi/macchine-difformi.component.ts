import { Component, OnInit, ViewChild } from '@angular/core';
import { MacchineService } from '../macchine.service';
import { Utils } from 'src/app/utils/utils.class';
import { Buffer } from 'buffer';
import { AppService } from 'src/app/app.service';
import { UserService } from 'src/app/user/user.service';
import { Export } from 'src/app/export.class';
import { ASmartTableComponent } from 'src/app/utils/modules/a-smart-table/a-smart-table.component';

declare let Swal: any;

@Component({
  selector: 'app-macchine-difformi',
  templateUrl: './macchine-difformi.component.html',
  styleUrls: ['./macchine-difformi.component.scss']
})
export class MacchineDifformiComponent implements OnInit {

  macchine: any;
  idUtente: any;
  isRegione: any;
  @ViewChild('table') tableRef?: ASmartTableComponent;

  constructor(
    public ms: MacchineService,
    private app: AppService,
    private us: UserService
  ) { }

  ngOnInit(): void {
    this.app.pageName = 'Macchine difformi';
    this.us.user.subscribe((data: any) => {
      this.idUtente = data.idUtente;
      this.isRegione = data.ruoloUtente.toUpperCase().includes('REGIONE');
      this.ms.getMacchine().subscribe((res) => {
        console.log("res:", res);
        this.macchine = res;
      })
    })

  }

  scaricaInfoFile(idMacchina: any): void {
    // Utils.showSpinner(true);

    let selMacchina: any;

    this.macchine.forEach((elem: any) => {
      if (elem.id_macchina === idMacchina) selMacchina = elem;
    });

    if (selMacchina != null) {
      this.ms.downloadInfoFile(selMacchina.id_macchina).subscribe((data: any) => {
        try {
          console.log("data:", data);
          Utils.download(data.body, `${data.headers.get('content-disposition').split('filename="')[1].replaceAll('"', '')}`);
        } catch (error) {
          Swal.fire({
            text: 'Errore nella generazione del file!',
            icon: 'error',
          });
        } finally {
          // Utils.showSpinner(false);
        }
      });

    }
  }

  eliminaInfoFile(idMacchina: any): void {
    // Utils.showSpinner(true);

    Swal.fire({
      title: 'Sei sicuro di voler eliminare la macchina selezionata?',
      icon: 'warning',
      showDenyButton: true,
      confirmButtonText: 'Si',
      customClass: {
        confimButton: 'btn btn-outline-blue',
        denyButton: 'btn btn-outline-red',
      },
    }).then((res: any) => {
      if (res.isConfirmed) {
        let selMacchina: any;

        this.macchine.forEach((elem: any) => {
          if (elem.id_macchina === idMacchina) selMacchina = elem;
        });

        if (selMacchina != null) {
          this.ms.eliminaInfoFile(selMacchina.id_macchina).subscribe((data: any) => {
            try {
              this.ngOnInit();
            } catch (error) {
              Swal.fire({
                text: 'Errore nell\'eliminazione del file!',
                icon: 'error',
              });
            } finally {
              // Utils.showSpinner(false);
            }
          });
        }
      }
    })
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
    let table = document.getElementById('tabella-macchine')
      ?.firstChild as HTMLTableElement;
    if (!table) throw new Error('No table found.');
    if (full) {
      let temp = document.createElement('table');
      let row: HTMLTableRowElement;
      let cell: HTMLTableCellElement;
      let head = temp.createTHead();

      Array.from(table.tHead!.rows).forEach((r, i) => {
        if (r.getAttribute('class')?.includes('paginator-row'))
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
          'descr_tipo_macchina',
          'descr_costruttore',
          'modello',
          'data_inserimento',
          'filename'
        ]) {
          cell = row.insertCell();
          cell.innerText = p === 'data_inserimento' ? data[p] ? new Date(data[p]).toLocaleDateString() : '' : data[p];
        }
      });
      table = temp;
    }

    if (extension == 'csv') //se tel o csv uso la libreria
      // se � mobile utilizzo la libreria apposita compatibile con il celulare, altrimenti la nostra custom pi� personalizzata
      Export.tableExportXlsx(table, {
        predicate: (r) =>
          !r.hidden && !r.className.includes('paginator-wrapper'),
        skipColumns: [5]
        // skipColumns: [table.rows!.item(1)!.cells.length - 1],
      },
        extension);
    else // altrimenti uso la tabella html nell xls
      Export.exportTable(table, {
        predicate: (r) =>
          !r.hidden && !r.className.includes('paginator-wrapper'),
        skipColumns: [5]
        // skipColumns: [table.rows!.item(1)!.cells.length - 1],
      });

    /*
    Utils.exportTable(table, {
      predicate: (r) => !r.hidden && !r.className.includes('paginator-wrapper'),
      skipColumns: [8]
    });
    */
  }

}