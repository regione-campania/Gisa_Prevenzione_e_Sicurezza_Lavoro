import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ATabberComponent } from './a-tabber.component';

describe('ATabberComponent', () => {
  let component: ATabberComponent;
  let fixture: ComponentFixture<ATabberComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ATabberComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ATabberComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
