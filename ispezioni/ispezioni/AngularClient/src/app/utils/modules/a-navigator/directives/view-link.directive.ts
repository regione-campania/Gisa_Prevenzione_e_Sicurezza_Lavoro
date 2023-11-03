import { Directive, HostListener, Input } from "@angular/core";
import { ANavigatorService } from "../a-navigator.service";

@Directive({
  selector: '[viewLink]',
})
export class ViewLinkDirective {
  @Input('viewLink') linkTo?: string;

  constructor(protected navService: ANavigatorService) {}

  @HostListener('click')
  onClick() {
    this.navService.changeView(this.linkTo!);
  }
}
