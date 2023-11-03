import { deepCopy, isDeeplyEqual } from '..';

export class ValueTracker<T = any> {
  private _value!: T;
  private _originalValue!: T;
  private _isModified = false;

  constructor(value: T) {
    this.value = value;
    this._originalValue = deepCopy(this.value);
  }

  //methods
  updateValue(value: T) {
    if (typeof value === 'object' && value !== null)
      for (let key in value) this.value[key] = value[key];
    else this.value = value;
    this._isModified = true;
  }

  //computed props
  /** returns **true** if value is the same as original */
  public get isSame() {
    return isDeeplyEqual(this.value, this.originalValue);
  }

  //accessors
  public get value() {
    return this._value;
  }

  private set value(value) {
    this._value = value;
  }

  public get originalValue() {
    return this._originalValue;
  }

  public get isModified() {
    return this._isModified;
  }
}
