import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ATreeNodeComponent } from './a-tree-node.component';

describe('ATreeNodeComponent', () => {
  let component: ATreeNodeComponent;
  let fixture: ComponentFixture<ATreeNodeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ATreeNodeComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ATreeNodeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
