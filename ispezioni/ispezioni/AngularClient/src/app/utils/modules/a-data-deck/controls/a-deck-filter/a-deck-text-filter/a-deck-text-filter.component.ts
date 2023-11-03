import { Component, DoCheck, EventEmitter, Output } from '@angular/core';
import { FormControl, Validators } from '@angular/forms';
import { DataTextFilter } from 'src/app/utils/services/data-manager';
import { ADeckFilterComponent } from '../a-deck-filter.component';

@Component({
  selector: 'a-deck-text-filter',
  templateUrl: './a-deck-text-filter.component.html',
  styleUrls: ['../a-deck-filter.component.scss'],
})
export class ADeckTextFilterComponent extends ADeckFilterComponent {

  override get filter(): DataTextFilter {
    return this._filter as DataTextFilter;
  }

  override set filter(val: DataTextFilter) {
    this._filter = val;
  }

  updateValidity() {
    let previousValue = this.isValid;
    this.isValid = this.filter.pattern !== '';
    if(this.isValid !== previousValue)
      this.validityChange.emit(this.isValid);
  }

  getOptionLabel(opt: string) {
    switch (opt) {
      case 'not-contains':
        return 'non contiene';
      case 'starts-with':
        return 'inizia con';
      case 'ends-with':
        return 'termina con';
      default:
        return 'contiene';
    }
  }
}
