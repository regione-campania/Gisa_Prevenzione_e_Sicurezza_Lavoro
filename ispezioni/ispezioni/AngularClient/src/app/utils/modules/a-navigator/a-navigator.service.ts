import { EventEmitter, Injectable, Output } from '@angular/core';;
import { TRANSITION_TIME } from './a-navigator.animations';
import { ANavigatorComponent } from './a-navigator.component';
import { ViewCrumb, ViewPath } from './a-navigator.types';
import { ANavigatorBreadcrumbComponent } from './breadcrumb/a-navigator-breadcrumb.component';

/** A service that manages navigator's views. */
@Injectable()
export class ANavigatorService {
  navigator?: ANavigatorComponent;
  breadcrumb?: ANavigatorBreadcrumbComponent;
  private _storage: any = {};
  viewPath: ViewPath = [];
  viewPathChange = new EventEmitter();

  /**
   * Changes the navigator's active view.
   * If a view doesn't match 'viewNameOrIndex' then nothing changes.
   * @param viewNameOrIndex The name or index of a navigator view.
   */
  changeView(viewNameOrIndex: string | number) {
    if (this.navigator) {
      let view = typeof viewNameOrIndex === 'number' ?
        this.navigator.views?.get(viewNameOrIndex) :
        this.navigator.views?.find((v) => v.viewName?.toLowerCase() === viewNameOrIndex.toLowerCase());
      if (view && view !== this.navigator.activeView) {
        let viewCrumb = this.viewPath.find((vc) => vc.view === view);
        let activeViewCrumb = this.viewPath.find(vc => vc.view === this.navigator?.activeView)!;
        if (viewCrumb) { //then the viewCrumb is already present
          activeViewCrumb.state = 'next';
          viewCrumb.state = 'active';
          let slice = this.viewPath.slice(0, this.viewPath.indexOf(viewCrumb) + 1);
          this.viewPathChange.emit(slice);
          //waits for animation then updates navigator's view path
          setTimeout(() => this.viewPath = slice, TRANSITION_TIME);
        } else {
          viewCrumb = new ViewCrumb(view, 'next');
          this.viewPath.push(viewCrumb);
          this.viewPathChange.emit(this.viewPath);
          activeViewCrumb.state = 'previous';
          //waits Angular to insert new view in the view container, then sets its state to active to play the animation
          setTimeout(() => viewCrumb!.state = 'active', 0);
        }
        this.navigator.activeView = view;
        this.navigator.viewChange.emit(this.navigator.activeView);
      }
    }
  }

  /** Go to previous view. */
  goBack() {
    let viewCrumb = this.viewPath[this.viewPath.length - 2] ?? this.viewPath[0];
    this.changeView(viewCrumb.view.viewName!);
  }

  canGoBack() {
    return this.viewPath.length > 1;
  }

  /** Clears the storage. */
  clearStorage() {
    this._storage = {};
  }

  //accessors
  get storage(): any {
    return this._storage;
  }
}
