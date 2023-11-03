import { Directive } from "@angular/core";
import { DataManagerService } from "src/app/utils/services/data-manager/data-manager.service";
import { ASmartTableComponent } from "../a-smart-table.component";

@Directive()
export abstract class ATableControl {
  dm: DataManagerService;

  constructor(protected aSmartTable: ASmartTableComponent) {
    this.dm = this.aSmartTable.dm;
    this.aSmartTable.controls.push(this);
  }
}
