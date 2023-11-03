import { DataFilter, SelectionFilterConf } from "../..";
import { DataManagerService } from "../../data-manager.service";

export class DataSelectionFilter extends DataFilter {
  values: any[] = []; //set of values to search in
  valuesToFind: any[] = [];  // subset of values to find

  constructor(protected override dm: DataManagerService, filterConf: SelectionFilterConf) {
    super(dm, {field: filterConf.field, type: filterConf.type});
    this.values = filterConf.values;
  }

  condition = (value: any): boolean => {
    if(!value) return false;
    if (this.valuesToFind.length === 0) return true;
    return this.valuesToFind.map((toFind: any) => toFind.toLowerCase()).includes(value.toLowerCase());
  };

  clean() {
    this.valuesToFind = [];
  }
}
