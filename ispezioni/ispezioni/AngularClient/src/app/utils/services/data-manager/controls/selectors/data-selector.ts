import { DataControl, DataReflex, DataSelectorInterface } from '../..';
import { DataManagerService } from '../../data-manager.service';

export class DataSelector extends DataControl implements DataSelectorInterface {
  private _disabled = false;

  constructor(
    protected override dm: DataManagerService,
    public readonly dataReflex: DataReflex,
  ) {
    super(dm);
  }

  select() {
    if (!this.disabled) {
      this.dataReflex.selected = true;
      this.markAsDirty();
    }
  }

  unselect() {
    if (!this.disabled) {
      this.dataReflex.selected = false;
      this.markAsDirty();
    }
  }

  toggle() {
    if (!this.disabled) {
      this.dataReflex.selected = !this.dataReflex.selected;
      this.markAsDirty();
    }
  }

  enable(): void {
    this._disabled = false;
    this.markAsDirty();
  }

  disable(): void {
    this._disabled = true;
    this.markAsDirty();
  }

  //accessors
  public get value() {
    return this.dataReflex?.selected ?? false;
  }

  public get disabled() {
    return this._disabled ?? false;
  }

  public get data() {
    return this.dm.data[this.dataReflex.pointer];
  }

}
