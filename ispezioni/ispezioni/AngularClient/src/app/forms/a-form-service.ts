import { Injectable } from '@angular/core';
import {
  AbstractControl,
  FormArray,
  FormControl,
  FormGroup,
  ValidatorFn,
  Validators,
} from '@angular/forms';

//provides utility functions for form handling
@Injectable()
export class AFormService {
  lockInput(input: any) {
    if (input instanceof HTMLInputElement) input.readOnly = true;
    else
      console.warn(
        'Paramenter is not of type HTMLInputElement. Nothing changed.'
      );
  }

  unlockInput(input: any) {
    if (input instanceof HTMLInputElement) input.readOnly = false;
    else
      console.warn(
        'Paramenter is not of type HTMLInputElement. Nothing changed.'
      );
  }

  /**
   * Sets validator(s) of an AbstractControl
   * @param control An AbstractControl. If control is a group or array, sets validators of all of its discendants recursively.
   * @param validators
   */

  setValidators(
    control: AbstractControl,
    validators: ValidatorFn | ValidatorFn[] | null
  ) {
    if (control instanceof FormControl) {
      control.setValidators(validators);
      control.updateValueAndValidity();
    } else if (control instanceof FormGroup || control instanceof FormArray) {
      if (Array.isArray(control.controls)) {
        for (let c of control.controls) this.setValidators(c, validators);
      } else {
        for (let k in control.controls)
          this.setValidators(control.controls[k], validators);
      }
    } else {
      console.log(control);
      throw new Error('Invalid argument');
    }
  }

  /**
   * Clears validator(s) of an AbstractControl
   * @param control An AbstractControl. If control is a group or array, slears validators of all of its discendants recursively.
   */

  clearValidators(control: AbstractControl) {
    if (control instanceof FormControl) {
      control.clearValidators();
      control.updateValueAndValidity();
    } else if (control instanceof FormGroup || control instanceof FormArray) {
      if (Array.isArray(control.controls)) {
        for (let c of control.controls) this.clearValidators(c);
      } else {
        for (let k in control.controls)
          this.clearValidators(control.controls[k]);
      }
    } else {
      console.log(control);
      throw new Error('Invalid argument');
    }
  }

  /**
   * Adds validator(s) to an AbstractControl
   * @param control An AbstractControl. If control is a group or array, adds validators to all of its discendants recursively.
   * @param validators
   */

  addValidators(
    control: AbstractControl,
    validators: ValidatorFn | ValidatorFn[]
  ) {
    if (control instanceof FormControl) {
      control.addValidators(validators);
      control.updateValueAndValidity();
    } else if (control instanceof FormGroup || control instanceof FormArray) {
      if (Array.isArray(control.controls)) {
        for (let c of control.controls) this.addValidators(c, validators);
      } else {
        for (let k in control.controls)
          this.addValidators(control.controls[k], validators);
      }
    } else {
      console.log(control);
      throw new Error('Invalid argument');
    }
  }

  /**
   * Removes validator(s) from an AbstractControl
   * @param control An AbstractControl. If control is a group or array, removes validators from all of its discendants recursively.
   * @param validators
   */

  removeValidators(
    control: AbstractControl,
    validators: ValidatorFn | ValidatorFn[]
  ) {
    if (control instanceof FormControl) {
      control.removeValidators(validators);
      control.updateValueAndValidity();
    } else if (control instanceof FormGroup || control instanceof FormArray) {
      if (Array.isArray(control.controls)) {
        for (let c of control.controls) this.removeValidators(c, validators);
      } else {
        for (let k in control.controls)
          this.removeValidators(control.controls[k], validators);
      }
    } else {
      console.log(control);
      throw new Error('Invalid argument');
    }
  }
}
