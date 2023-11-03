import { Directive, Input, TemplateRef } from '@angular/core';
import { AStep } from '.';

@Directive({
  selector: '[aStep]'
})
export class AStepDirective implements AStep {
  @Input('aStep') label: string = '';
  @Input() completed: boolean = false;
  @Input() enabled: boolean = true;
  @Input() data?: any;

  index = -1;
  animationState?: 'in' | 'out-left' | 'out-right';

  constructor(public template: TemplateRef<any>) { }

}
