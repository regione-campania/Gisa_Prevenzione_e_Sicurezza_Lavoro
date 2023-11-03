import {
  Component,
  EventEmitter,
  Input,
  OnChanges,
  OnDestroy,
  OnInit,
  Output,
  SimpleChanges,
} from '@angular/core';
import {
  DataSelector,
  DataSelectorInterface,
} from 'src/app/utils/services/data-manager';
import { DataMasterSelector } from 'src/app/utils/services/data-manager/controls/selectors/data-master-selector';
import { ATableControl } from '../a-table-control.directive';

@Component({
  selector: 'a-table-selector',
  templateUrl: './a-table-selector.component.html',
  styleUrls: ['./a-table-selector.component.scss'],
})
export class ATableSelectorComponent
  extends ATableControl
  implements OnInit
{
  @Input('data') inputData: any;
  @Input('selected') inputSelected = false;
  @Input('disabled') inputDisabled = false;
  @Output('onChange') changeEvent = new EventEmitter<ATableSelectorComponent>();

  private _selector?: DataSelector;

  ngOnInit() {
    this._selector = this.dm.findSelector(this.inputData);
    if(this._selector && !this._selector.dirty) {
      if(this.inputSelected) this.select();
      if(this.inputDisabled) this.disable();
    }
  }

  onChange(value: boolean) {
    value ? this.select() : this.unselect();
    this.changeEvent.emit(this);
  }

  select() {
    this.selector?.select();
  }

  unselect() {
    this.selector?.unselect();
  }

  toggle() {
    this.selector?.toggle();
  }

  enable() {
    this.selector?.enable();
  }

  disable() {
    this.selector?.disable();
  }

  //accessors
  get selector() {
    return this._selector;
  }

  get data() {
    return this._selector?.data;
  }

  get value() {
    return this.selector?.value ?? false;
  }

  get disabled() {
    return this._selector?.disabled ?? false;
  }
}
