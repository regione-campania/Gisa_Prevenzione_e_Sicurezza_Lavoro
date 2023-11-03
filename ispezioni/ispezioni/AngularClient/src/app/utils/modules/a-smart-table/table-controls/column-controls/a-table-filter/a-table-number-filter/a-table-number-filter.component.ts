import { Component, Input } from '@angular/core';
import { DataFilter } from 'src/app/utils/services/data-manager';
import { DataNumberFilter } from 'src/app/utils/services/data-manager/controls/filters/data-number.filter';

@Component({
  selector: 'a-table-number-filter',
  templateUrl: './a-table-number-filter.component.html',
  styleUrls: ['../a-table-filter.component.scss'],
})
export class ATableNumberFilterComponent {
  @Input('filter') _filter?: DataFilter;

  get filter() {
    return this._filter as DataNumberFilter;
  }

  set filter(filter) {
    this._filter = filter;
  }
}
