import { DataManagerService } from "../data-manager.service";

export abstract class DataControl {
  protected _dirty = false; //true when the control original value is changed

  constructor(protected dm: DataManagerService) {}

  markAsDirty() {
    this._dirty = true;
  }

  public get dirty() {
    return this._dirty;
  }
}
