import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TrasferimentoIspezioniComponent } from './trasferimento-ispezioni.component';

describe('TrasferimentoIspezioniComponent', () => {
  let component: TrasferimentoIspezioniComponent;
  let fixture: ComponentFixture<TrasferimentoIspezioniComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ TrasferimentoIspezioniComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(TrasferimentoIspezioniComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
