import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NuovaMacchinaComponent } from './nuova-macchina.component';

describe('NuovaMacchinaComponent', () => {
  let component: NuovaMacchinaComponent;
  let fixture: ComponentFixture<NuovaMacchinaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ NuovaMacchinaComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(NuovaMacchinaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
