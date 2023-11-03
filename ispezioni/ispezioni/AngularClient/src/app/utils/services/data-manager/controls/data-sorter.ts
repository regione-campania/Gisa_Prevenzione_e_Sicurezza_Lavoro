import { compare, or, parseValue } from "../../../../utils/lib";
import { DataManagerService } from "../data-manager.service";
import { SorterConf, SorterType, SortOrder } from "../../data-manager";
import { DataControl } from "./data-control";

export class DataSorter extends DataControl {
  field: string;
  type: SorterType;
  sortOrder: SortOrder = 'none';

  constructor(protected override dm: DataManagerService, sorterConf: SorterConf) {
    super(dm);
    this.field = sorterConf.field;
    this.type = sorterConf.type;
  }

  sort() {
    let indexOfThis = this.dm.activeSorters.indexOf(this);
    if (this.sortOrder === 'none') {
      if (indexOfThis >= 0)  //this is included
        this.dm.activeSorters.splice(indexOfThis, 1);
    }
    else {
      if (indexOfThis < 0) //this is not included
        this.dm.activeSorters.push(this);
    }
    if (this.dm.activeSorters.length > 0) {
      this.dm.dataReflex = this.dm.dataReflex.sort((a, b) => {
        let x, y, comparison;
        let comparisons: number[] = [];
        this.dm.activeSorters.forEach((s) => {
          x = parseValue(this.dm.data[a.pointer][s.field], s.type);
          y = parseValue(this.dm.data[b.pointer][s.field], s.type);
          comparison = compare(x, y);
          if (s.sortOrder === 'desc') comparison = -comparison;
          comparisons.push(comparison);
        });
        return or(...comparisons);
      });
    }
    else {
      this.dm.resetAllSorters();
    }
  }

  reset() {
    this.sortOrder = 'none';
    this.sort();
  }
}



