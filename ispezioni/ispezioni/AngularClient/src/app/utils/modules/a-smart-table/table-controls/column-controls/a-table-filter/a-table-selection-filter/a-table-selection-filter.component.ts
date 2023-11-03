import { Component, Input, OnInit, SimpleChanges, ViewChild } from '@angular/core';
import { AMultiSelectComponent } from 'src/app/utils/components/a-multi-select/a-multi-select.component';
import { DataFilter, DataSelectionFilter } from 'src/app/utils/services/data-manager';

@Component({
  selector: 'a-table-selection-filter',
  templateUrl: './a-table-selection-filter.component.html',
  styleUrls: ['../a-table-filter.component.scss'],
})
export class ATableSelectionFilterComponent implements OnInit {
  @ViewChild('ms') multiselect?: AMultiSelectComponent;
  @Input('filter') _filter?: DataFilter;

  get filter() {
    return this._filter as DataSelectionFilter;
  }

  set filter(filter) {
    this._filter = filter;
  }

  ngOnInit(): void {
    this.filter.resetted.subscribe(() => {
      this.multiselect?.reset();
    })
  }
}
