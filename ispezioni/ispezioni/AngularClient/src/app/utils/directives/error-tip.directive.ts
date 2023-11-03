import {
  Directive,
  ElementRef,
  HostListener,
  Input,
  OnChanges,
  SimpleChanges,
} from '@angular/core';
import { Popover } from 'bootstrap';

@Directive({
  selector: '[errorTip]',
})
export class ErrorTipDirective implements OnChanges {
  @Input('errorTip') errorMessage: string = 'GENERIC ERROR';

  element: HTMLElement;
  popover: Popover;

  constructor(private _elementRef: ElementRef) {
    this.element = this._elementRef.nativeElement;
    this.popover = this._initPopover();
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (
      changes['errorMessage'].currentValue !==
      changes['errorMessage'].previousValue
    ) {
      this.popover.dispose();
      this.popover = this._initPopover();
    }
  }

  private _initPopover() {
    return new Popover(this.element, {
      content: this.errorMessage,
      container: 'body',
      placement: 'top',
      customClass: 'error-popover',
      trigger: 'manual',
    });
  }

  @HostListener('focus', ['$event'])
  onFocus() {
    if (this.isControlInvalid) this.popover.show();
  }

  @HostListener('blur')
  onBlur() {
    this.popover.hide();
  }

  @HostListener('input')
  onInput() {
    //waits Angular input's value change detection
    setTimeout(() => {
      if (this.isControlInvalid)
        this.popover.show();
      else this.popover.hide();
    }, 0);
  }

  @HostListener('change')
  onChange() {
    //waits Angular input's value change detection
    setTimeout(() => {
      if (this.isControlInvalid)
        this.popover.show();
      else this.popover.hide();
    }, 0);
  }

  get isControlInvalid() {
    return (
      this.element.classList.contains('ng-dirty') &&
      this.element.classList.contains('ng-invalid')
    );
  }
}
