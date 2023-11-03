import { Component, EventEmitter, Input, OnChanges, OnDestroy, OnInit, Output, SimpleChanges } from '@angular/core';
import { DataSelector, DataSelectorInterface } from 'src/app/utils/services/data-manager';
import { DataMasterSelector } from 'src/app/utils/services/data-manager/controls/selectors/data-master-selector';
import { ATableControl } from '../a-table-control.directive';

@Component({
  selector: 'a-table-master-selector',
  templateUrl: './a-table-master-selector.component.html',
  styleUrls: ['./a-table-master-selector.component.scss']
})
export class ATableMasterSelectorComponent extends ATableControl implements OnInit {
  @Input('disabled') inputDisabled = false;
  @Input('mode') selectionMode: 'currentPage' | 'all' = 'currentPage';
  @Output('onChange') changeEvent = new EventEmitter<ATableMasterSelectorComponent>();

  private _selector?: DataMasterSelector;

  ngOnInit() {
    this._selector = this.dm.masterSelector;
    if(this._selector && !this._selector.dirty) {
      this._selector.selectionMode = this.selectionMode;
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

  get value() {
    return this.selector?.value ?? false;
  }

  get disabled() {
    return this._selector?.disabled ?? false;
  }
}
