import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AStepperComponent } from './a-stepper.component';

describe('AStepperComponent', () => {
  let component: AStepperComponent;
  let fixture: ComponentFixture<AStepperComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AStepperComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AStepperComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
