import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AStepperComponent } from './a-stepper.component';
import { AStepDirective } from './a-step.directive';



@NgModule({
  declarations: [
    AStepperComponent,
    AStepDirective,
  ],
  imports: [
    CommonModule,
  ],
  exports: [
    AStepperComponent,
    AStepDirective,
  ]
})
export class AStepperModule { }
