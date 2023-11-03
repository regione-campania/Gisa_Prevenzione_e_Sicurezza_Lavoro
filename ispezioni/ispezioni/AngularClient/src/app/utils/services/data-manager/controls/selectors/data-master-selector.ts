import { DataControl, DataReflex, DataSelectorInterface } from '../..';
import { DataManagerService } from '../../data-manager.service';

export class DataMasterSelector extends DataControl implements DataSelectorInterface {
  private _value = false;
  private _disabled = false;

  selectionMode: 'currentPage' | 'all' = 'currentPage';

  constructor(
    protected override dm: DataManagerService,
  ) {
    super(dm);
  }

  select() {
    if(!this.disabled) {
      if(this.selectionMode === 'all') {
        this.dm.selectors.forEach(s => s.select());
      }
      else {
        this.dm.selectors.forEach(s => {
          if(this.dm.content.find(reflex => reflex.pointer === s.dataReflex.pointer))
            s.select();
        });
      }
      this._value = true;
    }
  }

  unselect() {
    if(!this.disabled) {
      if(this.selectionMode === 'all') {
        this.dm.selectors.forEach(s => s.unselect());
        this._value = true;
      }
      else {
        this.dm.selectors.forEach(s => {
          if(this.dm.content.find(reflex => reflex.pointer === s.dataReflex.pointer))
            s.unselect();
        });
      }
      this._value = false;
    }
  }

  toggle() {
    if(!this.disabled) {
      this._value = !this._value;
      this.value ? this.select() : this.unselect();
    }
  }

  enable(): void {
    this._disabled = false;
  }

  disable(): void {
    this._disabled = true;
  }

  //accessors
  public get value(): boolean {
    return this._value;
  }

  public get disabled() {
    return this._disabled;
  }

}
