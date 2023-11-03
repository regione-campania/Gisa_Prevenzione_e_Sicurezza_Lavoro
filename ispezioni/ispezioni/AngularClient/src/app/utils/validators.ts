import { AbstractControl } from "@angular/forms";

/* ValidatorFn
 * A function that receives a control and synchronously returns a map of validation errors if present,
 * otherwise null.
*/

function isNumber(control: AbstractControl) {
  return isNaN(+control.value) ? {isNumber: false} : null;
}

function isPositiveNumber(control: AbstractControl) {
  return isNumber(control) ? {isNumber: false} : (+control.value <= 0 ? {isPositiveNumber: false} : null);
}

function isEmptyString(control: AbstractControl) {
  return control.value.toString() === '' ? {isEmptyString: false} : null;;
}

export { isNumber, isEmptyString, isPositiveNumber }
