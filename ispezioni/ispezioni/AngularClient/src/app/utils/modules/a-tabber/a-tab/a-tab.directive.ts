import { Directive, Input, TemplateRef } from '@angular/core';

@Directive({
  selector: 'ng-template[aTab]'
})
export class ATabDirective {
  @Input('aTab') name: string = '';
  @Input() data?: any;

  constructor(public template: TemplateRef<any>) { }

}
