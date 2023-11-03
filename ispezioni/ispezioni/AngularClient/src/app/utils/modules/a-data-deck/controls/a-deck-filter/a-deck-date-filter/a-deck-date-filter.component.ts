import { AfterContentChecked, AfterViewChecked, Component, DoCheck, ElementRef, OnChanges, OnInit, SimpleChanges, ViewChild } from '@angular/core';
import { DataDateFilter } from 'src/app/utils/services/data-manager';
import { ADeckFilterComponent } from '../a-deck-filter.component';

@Component({
  selector: 'a-deck-date-filter',
  templateUrl: './a-deck-date-filter.component.html',
  styleUrls: ['../a-deck-filter.component.scss'],
})
export class ADeckDateFilterComponent extends ADeckFilterComponent implements OnInit {
  //separate validity for view purposes
  isExactDateValid = false;
  isStartDateValid = false;
  isEndDateValid = false;

  ngOnInit() {
    this.filter.resetted.subscribe(() => {
      this.updateValidity();
    })
  }

  getOptionLabel(opt: string) {
    switch (opt) {
      case 'from-date':
        return 'da';
      case 'till-date':
        return 'fino a';
      case 'range':
        return 'intervallo';
      default:
        return 'data esatta';
    }
  }

  updateValidity() {
    let previousValue = this.isValid;
    if(this.filter.selectedOption !== 'range') {
      this.isValid = this.isExactDateValid = this._isDateValid(this.filter.exactDate);
    }
    else {
      this.isStartDateValid = this._isDateValid(this.filter.startDate);
      this.isEndDateValid = this._isDateValid(this.filter.endDate);
      this.isValid =
        this.isStartDateValid && this.isEndDateValid;
    }
    if(this.isValid !== previousValue)
      this.validityChange.emit(this.isValid);
  }

  private _isDateValid(date: string | Date | undefined) {
    if(!date) return false;
    return date.toString() !== 'Invalid Date';
  }

  override get filter(): DataDateFilter {
    return this._filter as DataDateFilter;
  }

  override set filter(val: DataDateFilter) {
    this._filter = val;
  }

}
