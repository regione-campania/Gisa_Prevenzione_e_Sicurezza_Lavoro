import {
  Component,
  ContentChild,
  Input,
  OnChanges,
  SimpleChanges,
} from '@angular/core';
import { ATemplateDirective } from '../../directives/a-template.directive';
import { DataManagerService } from '../../services/data-manager/data-manager.service';
import { NgbOffcanvas, NgbOffcanvasRef } from '@ng-bootstrap/ng-bootstrap';
import { ADataDeckFilterConf, ADataDeckSorterConf } from '.';
import { DataFilter, DataSorter } from '../../services/data-manager';

@Component({
  selector: 'a-data-deck',
  templateUrl: './a-data-deck.component.html',
  styleUrls: ['./a-data-deck.component.scss'],
  providers: [DataManagerService],
})
export class ADataDeckComponent implements OnChanges {
  @Input() data: any[] = [];
  @Input('paginator') includePaginator: boolean = false;

  @ContentChild(ATemplateDirective) cardTemplate?: ATemplateDirective;

  private _filtersConf: ADataDeckFilterConf[] = [];
  private _sortersConf: ADataDeckSorterConf[] = [];
  selectedFilter?: DataFilter;
  selectedSorter?: DataSorter;
  private _openedOffcanvas?: NgbOffcanvasRef;

  constructor(
    public dm: DataManagerService,
    public offcanvasService: NgbOffcanvas
  ) {}

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['data'].previousValue !== changes['data'].currentValue) {
      if (this.data) {
        this.dm.data = this.data;
      }
    }
  }

  selectFilter(field: string) {
    this.selectedFilter = this.dm.findFilter(field);
  }

  selectSorter(field: string) {
    this.selectedSorter = this.dm.findSorter(field);
  }

  getFilterLabel(filter: DataFilter) {
    return this.filtersConf.find((f) => f.field === filter.field)?.label;
  }

  getSorterLabel(sorter: DataSorter) {
    return this.sortersConf.find((s) => s.field === sorter.field)?.label;
  }

  //getters & setters
  @Input('filters')
  get filtersConf() {
    return this._filtersConf;
  }

  set filtersConf(conf: ADataDeckFilterConf[]) {
    this._filtersConf = conf;
    this.filtersConf.forEach((c) => {
      this.dm.createFilter({
        field: c.field,
        type: c.type,
        values: c.values,
      });
    });
  }

  @Input('sorters')
  get sortersConf() {
    return this._sortersConf;
  }

  set sortersConf(conf: ADataDeckSorterConf[]) {
    this._sortersConf = conf;
    this.sortersConf.forEach((c) => {
      this.dm.createSorter({
        field: c.field,
        type: c.type,
      });
    });
  }

  get deckContent() {
    return (
      (!this.includePaginator || !this.dm.paginator) ?
      this.dm.dataReflex :
      this.dm.paginator.currentPage.content
    );
  }

  get openedOffcanvas() {
    return this._openedOffcanvas;
  }

  set openedOffcanvas(offcanvasRef) {
    this._openedOffcanvas = offcanvasRef;
    this._openedOffcanvas?.dismissed.subscribe(() => {
      this.selectedFilter = undefined;
      this.selectedSorter = undefined;
    })
    this._openedOffcanvas?.closed.subscribe(() => {
      this.selectedFilter = undefined;
      this.selectedSorter = undefined;
    })
  }
}
