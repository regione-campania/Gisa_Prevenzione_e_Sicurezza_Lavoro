import { Component, Input } from '@angular/core';
import { DataDateFilter, DataFilter } from 'src/app/utils/services/data-manager';

@Component({
  selector: 'a-table-date-filter',
  templateUrl: './a-table-date-filter.component.html',
  styleUrls: ['../a-table-filter.component.scss'],
})
export class ATableDateFilterComponent {
  @Input('filter') _filter?: DataFilter;

  get filter() {
    return this._filter as DataDateFilter;
  }

  set filter(filter) {
    this._filter = filter;
  }
}
