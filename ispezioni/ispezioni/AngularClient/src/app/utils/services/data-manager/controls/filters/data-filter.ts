import { EventEmitter } from '@angular/core';
import { intersectArray } from '../../../../../utils/lib';
import { DataControl } from '../..';
import { DataManagerService } from '../../data-manager.service';
import { FilterConf, FilterType } from '../../';

export abstract class DataFilter extends DataControl {
  field: string;
  type: FilterType;
  affected: number[] = [];
  discarded: number[] = [];
  protected _isActive = false;

  //events
  applied = new EventEmitter();
  resetted = new EventEmitter();

  abstract condition: (el: any) => boolean;
  abstract clean(): void;

  constructor(protected override dm: DataManagerService, filterConf: FilterConf) {
    super(dm);
    this.field = filterConf.field;
    this.type = filterConf.type;
  }

  apply() {
    this.reset();
    let searchFields = this.field.split(' | ');
    this.dm.data.forEach((d: any, i: number) => {
      let conditionMet = false, j = 0;
      while (!conditionMet && j < searchFields.length) {
        if (this.condition(d[searchFields[j++]]))
          conditionMet = true;
      }
      conditionMet ? this.affected.push(i) : this.discarded.push(i);
    });
    this._isActive = true;
    this.onChange();
    this.applied.emit();
  }

  reset(skipOnChange = false) {
    this.affected = [];
    this.discarded = [];
    this._isActive = false;
    if(!skipOnChange)
      this.onChange();
    this.resetted.emit();
  }

  protected onChange() {
    const activeFilters = this.dm.activeFilters;
    if (activeFilters.length === 0) {
      this.dm.resetAllFilters();
    } else {
      //shows only elements that meet condition of all filters
      let intersection = activeFilters[0].affected;
      for (let i = 1; i < activeFilters.length; i++) {
        intersection = intersectArray(
          intersection,
          activeFilters[i].affected
        );
      }
      this.dm.dataReflex.forEach((r) => {
        r.visible = intersection.includes(r.pointer);
      });
      this.dm.dataReflexChange.emit();
    }
  }

  //getters & setters
  get isActive() {
    return this._isActive;
  }
}
