import { TestBed } from '@angular/core/testing';

import { MacchineService } from './macchine.service';

describe('MacchineService', () => {
  let service: MacchineService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(MacchineService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
