import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ANavigatorComponent } from './a-navigator.component';
import { ANavigatorViewDirective } from './directives/a-navigator-view.directive';
import { ANavigatorService } from './a-navigator.service';
import { ViewLinkDirective } from './directives/view-link.directive';
import { ANavigatorBreadcrumbComponent } from './breadcrumb/a-navigator-breadcrumb.component';

@NgModule({
  declarations: [
    ANavigatorComponent,
    ANavigatorViewDirective,
    ANavigatorBreadcrumbComponent,
    ViewLinkDirective,
  ],
  imports: [CommonModule],
  exports: [ANavigatorComponent, ANavigatorViewDirective, ViewLinkDirective],
  providers: [ANavigatorService],
})
export class ANavigatorModule {}
