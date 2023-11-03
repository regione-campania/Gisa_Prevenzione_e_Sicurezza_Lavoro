import {
  AfterContentInit,
  Component,
  ContentChildren,
  EventEmitter,
  Input,
  OnDestroy,
  OnInit,
  Output,
  QueryList,
  TemplateRef,
} from '@angular/core';
import { navigationTrigger } from './a-navigator.animations';
import { ANavigatorService } from './a-navigator.service';
import { ViewCrumb } from './a-navigator.types';
import { ANavigatorViewDirective } from './directives/a-navigator-view.directive';

/**
 * Component that implements a custom navigation.
 */

@Component({
  selector: 'a-navigator',
  templateUrl: './a-navigator.component.html',
  styleUrls: ['./a-navigator.component.scss'],
  animations: [navigationTrigger],
})
export class ANavigatorComponent implements OnInit, AfterContentInit, OnDestroy {
  @ContentChildren(ANavigatorViewDirective)
  views?: QueryList<ANavigatorViewDirective>;
  activeView?: ANavigatorViewDirective;

  @Input() header?: TemplateRef<any>;
  @Input() footer?: TemplateRef<any>;
  @Input() closable = false;

  @Output() viewChange = new EventEmitter();
  @Output('onClose') closeEvent = new EventEmitter();

  constructor(protected service: ANavigatorService) {
    this.service.navigator = this;
  }

  ngOnInit(): void {}

  ngAfterContentInit(): void {
    this.activeView = this.rootView; //initialize navigator to root view
    this.viewPath.push(new ViewCrumb(this.activeView!, 'active'));
    this.service.viewPathChange.emit(this.viewPath);
  }

  ngOnDestroy(): void {
    this.service.viewPath = [];
  }

  //accessors
  get rootView() {
    return this.views?.find((v) => v.viewName === 'root') ?? this.views?.first;
  }

  get breadcrumb() {
    return this.service.breadcrumb;
  }

  get viewPath() {
    return this.service.viewPath;
  }

}
