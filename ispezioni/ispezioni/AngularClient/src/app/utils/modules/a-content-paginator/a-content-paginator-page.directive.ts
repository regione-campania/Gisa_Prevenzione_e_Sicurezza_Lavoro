import { Directive, Input, TemplateRef } from '@angular/core';

@Directive({
  selector: 'ng-template[aContentPage]'
})
export class AContentPaginatorPageDirective {
  @Input('aContentPage') pageTitle?: string;
  @Input() pageNumber: number = 0;

  constructor(public template: TemplateRef<any>) { }

}
