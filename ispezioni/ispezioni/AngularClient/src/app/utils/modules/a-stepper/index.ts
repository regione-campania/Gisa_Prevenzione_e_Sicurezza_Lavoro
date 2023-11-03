import { TemplateRef } from "@angular/core";
export { AStepperComponent } from './a-stepper.component';
export { AStepDirective } from './a-step.directive';

export interface AStep {
  label: string;
  index: number;
  template: TemplateRef<any>;
  completed: boolean;
  enabled: boolean;
  data?: any; //optional data
}
