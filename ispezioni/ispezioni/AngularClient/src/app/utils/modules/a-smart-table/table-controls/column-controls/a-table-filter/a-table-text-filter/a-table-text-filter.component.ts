import { Component, Input } from '@angular/core';
import { DataFilter, DataTextFilter } from 'src/app/utils/services/data-manager';

@Component({
  selector: 'a-table-text-filter',
  templateUrl: './a-table-text-filter.component.html',
  styleUrls: ['../a-table-filter.component.scss'],
})
export class ATableTextFilterComponent {
  @Input('filter') _filter?: DataFilter;

  get filter() {
    return this._filter as DataTextFilter;
  }

  set filter(filter) {
    this._filter = filter;
  }
}
