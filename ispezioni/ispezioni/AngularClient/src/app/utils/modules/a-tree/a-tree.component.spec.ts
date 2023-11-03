import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ATreeComponent } from './a-tree.component';

describe('ATreeComponent', () => {
  let component: ATreeComponent;
  let fixture: ComponentFixture<ATreeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ATreeComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ATreeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
