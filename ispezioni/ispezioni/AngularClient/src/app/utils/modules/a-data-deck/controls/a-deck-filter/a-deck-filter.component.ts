import { AfterContentChecked, AfterViewChecked, Component, ContentChild, DoCheck, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { DataFilter } from '../../../../services/data-manager';

@Component({
  selector: 'a-deck-filter',
  templateUrl: './a-deck-filter.component.html',
  styleUrls: ['./a-deck-filter.component.scss']
})
export class ADeckFilterComponent {
  @Output() validityChange = new EventEmitter<boolean>();

  isValid = false;
  protected _filter?: DataFilter;

  @Input()
  get filter() {
    return this._filter;
  }

  set filter(filter) {
    this._filter = filter;
  }

}
