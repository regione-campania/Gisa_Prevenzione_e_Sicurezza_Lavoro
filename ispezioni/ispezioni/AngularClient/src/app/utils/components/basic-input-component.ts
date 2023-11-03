import { Directive, Input } from "@angular/core";
import { ControlValueAccessor } from "@angular/forms";

@Directive()
export abstract class BasicInputComponent<TValue = any> implements ControlValueAccessor {
  protected _onChange: any = () => null;
  protected _onTouch: any = () => null;
  protected _disabled: boolean = false;

  @Input() value: TValue | null = null;

  constructor() {}

  writeValue(obj: any): void {
    this.value = obj;
  }

  registerOnChange(fn: any): void {
    this._onChange = fn;
  }

  registerOnTouched(fn: any): void {
    this._onTouch = fn;
  }

  setDisabledState?(isDisabled: boolean): void {
    this._disabled = isDisabled;
  }

  //accessors
  get onChange() {
    return this._onChange;
  }

  get onTouch() {
    return this._onTouch;
  }

  get disabled() {
    return this._disabled;
  }
}
