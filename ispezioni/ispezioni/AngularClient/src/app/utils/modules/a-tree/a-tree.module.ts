import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ATreeComponent } from './a-tree.component';
import { ATreeNodeComponent } from './a-tree-node/a-tree-node.component';
import { FormsModule } from '@angular/forms';
import { ATreeFilterComponent } from './a-tree-filter/a-tree-filter.component';
import { NgbTooltipModule } from '@ng-bootstrap/ng-bootstrap';



@NgModule({
  declarations: [
    ATreeComponent,
    ATreeNodeComponent,
    ATreeFilterComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    NgbTooltipModule,
  ],
  exports: [
    ATreeComponent,
    ATreeFilterComponent
  ]
})
export class ATreeModule { }
