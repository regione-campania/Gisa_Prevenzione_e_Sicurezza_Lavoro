import { toDateWithoutTime } from '../../../../../utils/lib';
import { DataFilter, DateFilterOption } from '../..';

export class DataDateFilter extends DataFilter {
  selectedOption: DateFilterOption = 'exact-date';
  exactDate?: Date;
  startDate?: Date;
  endDate?: Date;

  condition = (value: string | Date) => {
    let x = value instanceof Date ? value : new Date(value);
    if (x.toString() === 'Invalid Date') return false;
    x = toDateWithoutTime(x);
    if (this.selectedOption === 'range') {
      if (!this.startDate) this.startDate = new Date(0); //EPOC
      if (!this.endDate) this.endDate = new Date();
      return (
        x >= toDateWithoutTime(this.startDate) &&
        x <= toDateWithoutTime(this.endDate)
      );
    } else {
      if (!this.exactDate)
        this.exactDate = new Date();
      let y = toDateWithoutTime(this.exactDate);
      switch (this.selectedOption) {
        case 'from-date':
          return x >= y;
        case 'till-date':
          return x <= y;
        default:
          //exact date
          return (
            x.getDate() === y.getDate() &&
            x.getMonth() === y.getMonth() &&
            x.getFullYear() === y.getFullYear()
          );
      }
    }
  };

  clean() {
    this.selectedOption = 'exact-date';
    this.exactDate = this.startDate = this.endDate = undefined;
  }

  get options(): DateFilterOption[] {
    return ['exact-date', 'from-date', 'till-date', 'range'];
  }
}
