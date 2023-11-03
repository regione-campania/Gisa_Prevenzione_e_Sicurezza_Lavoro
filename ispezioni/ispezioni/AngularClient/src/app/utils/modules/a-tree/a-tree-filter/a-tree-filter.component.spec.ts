import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ATreeFilterComponent } from './a-tree-filter.component';

describe('ATreeFilterComponent', () => {
  let component: ATreeFilterComponent;
  let fixture: ComponentFixture<ATreeFilterComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ATreeFilterComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ATreeFilterComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
