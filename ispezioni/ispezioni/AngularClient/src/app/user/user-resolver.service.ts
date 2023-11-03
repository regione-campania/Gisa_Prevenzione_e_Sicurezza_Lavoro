import { Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  Resolve,
  RouterStateSnapshot,
} from '@angular/router';
import { EMPTY, mergeMap, of } from 'rxjs';
import { User } from './user.interface';
import { UserService } from './user.service';

@Injectable({
  providedIn: 'root',
})
export class UserResolverService implements Resolve<User> {
  constructor(private us: UserService) {}

  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    return this.us.user.pipe(
      mergeMap((user) => {
        if (user) return of(user);
        return EMPTY;
      })
    );
  }
}
