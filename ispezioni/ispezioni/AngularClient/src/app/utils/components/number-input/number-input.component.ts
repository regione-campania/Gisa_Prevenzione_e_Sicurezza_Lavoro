import {
  Component,
  EventEmitter,
  forwardRef,
  Input,
  OnInit,
  Output,
} from '@angular/core';
import { NG_VALUE_ACCESSOR } from '@angular/forms';
import { BasicInputComponent } from '../basic-input-component';

@Component({
  selector: 'number-input',
  templateUrl: './number-input.component.html',
  styleUrls: ['./number-input.component.scss'],
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => NumberInputComponent),
      multi: true,
    },
  ],
})
export class NumberInputComponent
  extends BasicInputComponent<number>
  implements OnInit
{
  @Input() inputClass: string | null = null;
  @Input() max: number | null = null;
  @Input() min: number | null = null;
  @Input() step: number | null = null;
  @Input() placeholder: string | null = null;
  @Input() readonly: boolean | null = null;

  @Output('change') changeEvent = new EventEmitter<number>();

  ngOnInit(): void {}

  /**
   * Applies value if valid.
   * @param value The value to apply.
   * @returns true if the new value is valid, false otherwise.
   */
  applyValue(value: number) {
    if (!this._isChangeValid(value)) return false;
    this.value = value;
    this.onTouch(true); //sets the control 'touched'
    this.onChange(this.value); //reflects changes from view to model
    this.changeEvent.emit(this.value); //emits custom change event
    return true;
  }

  increase() {
    this.applyValue(
      this.value !== null ? this.value + 1 : this.min ?? this.max ?? 0
    );
  }

  decrease() {
    this.applyValue(
      this.value !== null ? this.value - 1 : this.min ?? this.max ?? 0
    );
  }

  onViewChange(target: any) {
    if (!this.applyValue(+target.value)) target.value = this.value;
  }

  private _isChangeValid(value: number) {
    if (this.readonly || this.disabled) return false;
    if (this.min !== null && value < this.min) return false;
    if (this.max !== null && value > this.max) return false;
    return true;
  }
}
