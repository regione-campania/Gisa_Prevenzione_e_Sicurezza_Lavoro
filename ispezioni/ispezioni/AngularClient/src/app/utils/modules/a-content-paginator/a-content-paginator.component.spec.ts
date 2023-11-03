import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AContentPaginatorComponent } from './a-content-paginator.component';

describe('AContentPaginatorComponent', () => {
  let component: AContentPaginatorComponent;
  let fixture: ComponentFixture<AContentPaginatorComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AContentPaginatorComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AContentPaginatorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
