import { TextFilterOption } from "../../";
import { DataFilter } from "./data-filter";

export class DataTextFilter extends DataFilter {
  pattern = '';
  selectedOption: TextFilterOption = 'contains';

  condition = (val: string) => {
    val = val ?? '';
    let a = val.toLowerCase();
    let b = this.pattern.toLowerCase();
    switch (this.selectedOption) {
      case 'not-contains': return !(a.includes(b));
      case 'starts-with': return a.startsWith(b);
      case 'ends-with': return a.endsWith(b);
      default: return a.includes(b);
    }
  };

  clean(): void {
    this.pattern = '';
  }

  get options(): TextFilterOption[]{
    return [
      'contains',
      'not-contains',
      'starts-with',
      'ends-with'
    ]
  }
}
