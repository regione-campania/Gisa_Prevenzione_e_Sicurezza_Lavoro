import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ATabberComponent } from './a-tabber.component';
import { ATabDirective } from './a-tab/a-tab.directive';



@NgModule({
  declarations: [
    ATabberComponent,
    ATabDirective
  ],
  imports: [
    CommonModule
  ],
  exports: [
    ATabberComponent,
    ATabDirective
  ]
})
export class ATabberModule { }
