import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { UtilsModule } from "src/app/utils/utils.module";
import { AColumnTriggerDirective } from "./a-column-trigger.directive";
import { ATableDateFilterComponent } from "./a-table-filter/a-table-date-filter/a-table-date-filter.component";
import { ATableFilterComponent } from "./a-table-filter/a-table-filter.component";
import { ATableNumberFilterComponent } from "./a-table-filter/a-table-number-filter/a-table-number-filter.component";
import { ATableSelectionFilterComponent } from "./a-table-filter/a-table-selection-filter/a-table-selection-filter.component";
import { ATableTextFilterComponent } from "./a-table-filter/a-table-text-filter/a-table-text-filter.component";
import { ATableSorterComponent } from "./a-table-sorter/a-table-sorter.component";

@NgModule({
  declarations: [
    AColumnTriggerDirective,
    ATableFilterComponent,
    ATableTextFilterComponent,
    ATableDateFilterComponent,
    ATableSelectionFilterComponent,
    ATableNumberFilterComponent,
    ATableSorterComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    UtilsModule,
  ],
  exports: [
    ATableFilterComponent,
    ATableSorterComponent
  ],
})
export class ColumnControlsModule {}
