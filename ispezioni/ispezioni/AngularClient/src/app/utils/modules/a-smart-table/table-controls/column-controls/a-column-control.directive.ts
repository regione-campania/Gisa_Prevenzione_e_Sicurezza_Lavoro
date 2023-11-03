import {
  AfterViewInit,
  Directive,
  Input,
  ViewChild,
} from '@angular/core';
import { ATableControl } from '../a-table-control.directive';
import { AColumnTriggerDirective } from './a-column-trigger.directive';

@Directive()
export abstract class AColumnControl extends ATableControl implements AfterViewInit {
  @Input() field?: string;
  @ViewChild(AColumnTriggerDirective) trigger?: AColumnTriggerDirective;

  ngAfterViewInit() {
    this.trigger?.element.addEventListener(this.trigger.event, () => {
      this.trigger?.action.call(this);
    });
  }
}
