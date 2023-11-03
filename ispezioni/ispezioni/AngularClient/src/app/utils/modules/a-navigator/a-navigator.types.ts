import { ANavigatorViewDirective } from './directives/a-navigator-view.directive';

class ViewCrumb {
  constructor(public view: ANavigatorViewDirective, public state: string) {}
}

type ViewPath = ViewCrumb[];

export { ViewCrumb, ViewPath };
