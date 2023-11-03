import {
  AfterViewInit,
  ChangeDetectorRef,
  Component,
  ContentChildren,
  ElementRef,
  Input,
  OnChanges,
  OnInit,
  QueryList,
  SimpleChanges,
  ViewChild,
} from '@angular/core';
import { ATemplateDirective } from '../../directives/a-template.directive';
import { DataManagerService } from '../../services/data-manager/data-manager.service';
import { ATableControl } from './table-controls/a-table-control.directive';
import { Utils } from '../../utils.class';

@Component({
  selector: 'a-smart-table',
  templateUrl: './a-smart-table.component.html',
  styleUrls: ['./a-smart-table.component.scss'],
  providers: [DataManagerService],
})
export class ASmartTableComponent implements OnChanges, OnInit, AfterViewInit {
  @ContentChildren(ATemplateDirective) templates?: QueryList<ATemplateDirective>;
  @ViewChild('table') table?: ElementRef;
  @Input('class') class?: string;
  @Input('data') data?: any[] = [];
  @Input('paginator') includePaginator = false;
  @Input('paginatorSide') paginatorSide: 'top' | 'bottom' | 'both' = 'top';
  @Input() rowsPerPage: 10 | 25 | 50 | 100 = 25;
  @Input('exportable') exportable?: boolean = true; // Tabella esportabile
  @Input('skipFirst') skipFirst?: boolean = true; // Skippa checkbox selezione
  @Input('fields') fields?: string[] = []; // Campi da esportare

  private _controls: ATableControl[] = [];

  constructor(public dm: DataManagerService, private changeDetector: ChangeDetectorRef) { }

  ngOnInit(): void {
    this.dm.dataReflexChange.subscribe(
      this.changeDetector.detectChanges()
    );
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['data'].previousValue !== changes['data'].currentValue) {
      if (this.data) {
        this.dm.data = this.data;
      }
    }
  }

  ngAfterViewInit(): void {
    console.log('HERE')
    const toolbarCell = this.table?.nativeElement.querySelector('.toolbar-cell') as HTMLTableCellElement;
    const paginatorCell = this.table?.nativeElement.querySelector('.paginator-cell') as HTMLTableCellElement;
    const firstRow = this.table?.nativeElement.querySelector('tr:not(.toolbar-row):not(.paginator-row)') as HTMLTableRowElement;
    toolbarCell.colSpan = paginatorCell.colSpan = firstRow ? firstRow.cells.length : 1;
  }

  exportTable(full: boolean): void {
    let table = this.table?.nativeElement as HTMLTableElement;

    if (!table) throw new Error("No Table Found!");

    let _skipColumns: number[];
    if (this.skipFirst == true) _skipColumns = [0]; else _skipColumns = [];

    // Tabella Completa
    if (full) {
      // Recupera tutti i dati da visualizzare
      let filteredData: any[] = [];
      this.dm.dataReflex.forEach((ref: any) => {
        if (ref.visible == true) {
          filteredData.push(this.dm.data[ref.pointer]);
        }
      })

      _skipColumns = [];
      let temp = document.createElement('table');
      let row: HTMLTableRowElement, cell: HTMLTableCellElement;
      let head = temp.createTHead();

      console.log("this.fields.length:", this.fields?.length);

      /*  Se il campo fields non è stato passato, allora prendi tutte
          le entries dei dati. */
      if (this.fields && this.fields?.length > 0) {
        // Costruisci l'header della tabella
        Array.from(table.tHead!.rows).forEach((r) => {
          row = head.insertRow();
          Array.from(r.cells!).forEach((c, i) => {
            if (i != 0 || this.skipFirst == false) {
              cell = row.insertCell();
              cell.innerText = c.innerText;
            }
          })
        })

        // Costruisci il body della tabella
        let body = temp.createTBody();

        filteredData!.forEach((d: any) => {
          row = body.insertRow();
          this.fields!.forEach((field: string) => {
            cell = row.insertCell();
            cell.innerText = d[field];
            if (field.includes('data')) {
              let _data = new Date(cell.innerText);
              cell.innerText = _data.toLocaleDateString('it-IT', {day:'2-digit', month: '2-digit', year: '2-digit'});
            }
          })
        })
      } else {
        // Costruisci l'header
        row = head.insertRow();
        for (const [key, value] of Object.entries(this.data![0])) {
          cell = row.insertCell();
          cell.innerText = key as string;
        }

        let body = temp.createTBody();

        filteredData?.forEach((d: any) => {
          row = body.insertRow();
          for (const [key, value] of Object.entries(d)) {
            cell = row.insertCell();
            cell.innerText = value as string;
          }
        })
      }

      table = temp;
    }

    Utils.exportTable(
      table, { filename: 'exportedFile', skipColumns: _skipColumns }
    );
  }

  //accessors
  get tableContent() {
    if (this.includePaginator && this.dm.paginator)
      return this.dm.paginator.currentPage.content;
    return this.dm.dataReflex.filter(d => d.visible);
  }

  get controls() {
    return this._controls;
  }

  get caption() {
    return this.templates?.find((t) => t.name === 'caption');
  }

  get head() {
    return this.templates?.find((t) => t.name === 'head');
  }

  get body() {
    return this.templates?.find((t) => t.name === 'body');
  }

  get footer() {
    return this.templates?.find((t) => t.name === 'footer');
  }

  get selectedData() {
    return this.dm.selectedData;
  }
}
