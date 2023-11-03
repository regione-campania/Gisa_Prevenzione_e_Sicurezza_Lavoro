import { Component } from '@angular/core';
import { breadcrumbTrigger } from '../a-navigator.animations';
import { ANavigatorService } from '../a-navigator.service';
import { ViewCrumb, ViewPath } from '../a-navigator.types';

@Component({
  selector: 'a-navigator-breadcrumb',
  templateUrl: './a-navigator-breadcrumb.component.html',
  styleUrls: ['./a-navigator-breadcrumb.component.scss'],
  animations: [breadcrumbTrigger]
})
export class ANavigatorBreadcrumbComponent {

  /**
   * A copy of ANavigatorService.viewPath that updates syncronously.
   */
  viewPath: ViewPath = [];

  constructor(public navService: ANavigatorService) {
    this.navService.breadcrumb = this;
    this.navService.viewPathChange.subscribe(viewPath => {
      this.viewPath = viewPath;
    });
  }

  //accessors
  get navigator() {
    return this.navService.navigator;
  }

}
