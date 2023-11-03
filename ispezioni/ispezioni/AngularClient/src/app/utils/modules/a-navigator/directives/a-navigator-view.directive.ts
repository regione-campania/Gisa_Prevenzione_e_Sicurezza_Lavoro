import { Directive, Input, TemplateRef } from "@angular/core";

@Directive({
  selector: 'ng-template[aNavigatorView]'
})
export class ANavigatorViewDirective {
  @Input('aNavigatorView') viewName?: string;

  constructor(public templateRef: TemplateRef<any>) {}
}
