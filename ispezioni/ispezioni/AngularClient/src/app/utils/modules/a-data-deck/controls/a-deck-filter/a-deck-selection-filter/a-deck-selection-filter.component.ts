import {
  Component,
  OnChanges,
  SimpleChanges,
  ViewChild,
} from '@angular/core';
import { DataSelectionFilter } from 'src/app/utils/services/data-manager';
import { ADeckFilterComponent } from '../a-deck-filter.component';

@Component({
  selector: 'a-deck-selection-filter',
  templateUrl: './a-deck-selection-filter.component.html',
  styleUrls: ['../a-deck-filter.component.scss'],
})
export class ADeckSelectionFilterComponent extends ADeckFilterComponent implements OnChanges
{
  @ViewChild('ms') multiselect: any;

  updateValidity() {
    let previousValue = this.isValid;
    this.isValid = this.filter.valuesToFind.length > 0;
    if(this.isValid !== previousValue)
      this.validityChange.emit(this.isValid);
  }

  override get filter(): DataSelectionFilter {
    return this._filter as DataSelectionFilter;
  }

  override set filter(val: DataSelectionFilter) {
    this._filter = val;
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (
      this.multiselect &&
      changes['filter'].previousValue !== changes['filter'].currentValue
    )
      this.multiselect.reset();
  }
}
