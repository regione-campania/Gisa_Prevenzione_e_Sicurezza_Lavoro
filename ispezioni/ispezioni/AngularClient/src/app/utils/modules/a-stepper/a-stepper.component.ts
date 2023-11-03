import {
  AfterContentInit,
  Component,
  ContentChildren,
  OnInit,
  QueryList,
} from '@angular/core';
import { AStepDirective } from './a-step.directive';

@Component({
  selector: 'a-stepper',
  templateUrl: './a-stepper.component.html',
  styleUrls: ['./a-stepper.component.scss'],
})
export class AStepperComponent implements OnInit, AfterContentInit {
  @ContentChildren(AStepDirective)
  steps?: QueryList<AStepDirective>;

  private _activeStep?: AStepDirective | undefined;
  path: AStepDirective[] = [];  //builded on the go

  constructor() {}

  ngOnInit(): void {}

  ngAfterContentInit(): void {
    //setting steps
    let i = 0;
    this.steps?.forEach((s) => (s.index = i++));
    this.stepTo(0);
  }

  /**
   * Retrieve a step by its index or its label
   * @param indexOrLabel The index or label of a step
   * @returns AStepDirective if is found or undefined
   */
  get(indexOrLabel: number | string) {
    if (typeof indexOrLabel === 'number') return this.steps?.get(indexOrLabel);
    return this.steps?.find((step) => step.label === indexOrLabel);
  }

  prev() {
    if (this.activeStep!.index > 1) this.stepTo(this.activeStep!.index - 1);
  }

  next() {
    if (this.activeStep!.index < this.steps!.length - 1)
      this.stepTo(this.activeStep!.index + 1);
  }

  stepTo(index: number) {
    if (!this.steps?.get(index)?.enabled) return;
    let newStep = this.steps?.get(index)!;
    if(!this.path.includes(newStep))
      this.path.push(newStep);
    this.activeStep = newStep;
  }

  //accessors
  public get activeStep(): AStepDirective | undefined {
    return this._activeStep;
  }

  private set activeStep(value: AStepDirective | undefined) {
    this._activeStep = value;
  }
}
