import { Component, Input, OnInit } from '@angular/core';
import { DataSorter, SorterType } from 'src/app/utils/services/data-manager';
import { AColumnControl } from '../a-column-control.directive';

@Component({
  selector: 'a-table-sorter',
  templateUrl: './a-table-sorter.component.html',
  styleUrls: ['./a-table-sorter.component.scss'],
})
export class ATableSorterComponent extends AColumnControl implements OnInit {
  @Input() type: SorterType = 'text';
  sorter?: DataSorter;

  ngOnInit(): void {
    if(!this.field)
      throw new Error('Provide a valid field for this sorter');
    this.sorter = this.dm.createSorter({
      field: this.field,
      type: this.type
    });
  }

  sort() {
    if(!this.sorter) return;
    if(this.sorter.sortOrder === 'desc')
      this.sorter.reset();
    else {
      this.sorter.sortOrder =
        this.sorter.sortOrder === 'none' ? 'asc' : 'desc';
      this.sorter.sort();
    }
  }
}

