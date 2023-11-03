import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ATablePaginatorComponent } from "./a-table-paginator/a-table-paginator.component";
import { ATableSelectorComponent } from "./a-table-selector/a-table-selector.component";
import { ColumnControlsModule } from "./column-controls/column-controls.module";
import { ATableMasterSelectorComponent } from './a-table-master-selector/a-table-master-selector.component';

@NgModule({
  declarations: [
    ATablePaginatorComponent,
    ATableSelectorComponent,
    ATableMasterSelectorComponent,
  ],
  imports: [
    CommonModule,
    FormsModule,
    ColumnControlsModule
  ],
  exports: [
    ATablePaginatorComponent,
    ATableSelectorComponent,
    ATableMasterSelectorComponent,
    ColumnControlsModule
  ]
})
export class TableControlsModule {}
