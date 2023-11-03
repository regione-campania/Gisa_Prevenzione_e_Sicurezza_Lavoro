import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
  HttpErrorResponse,
} from '@angular/common/http';
import { UserService } from './user/user.service';
import { catchError, Observable, throwError } from 'rxjs';
import { Router } from '@angular/router';
import { Utils } from 'src/app/utils/utils.class';
declare let Swal: any;

@Injectable()
export class TokenInterceptor implements HttpInterceptor {
  constructor(public us: UserService, private router: Router) {}

  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    request = request.clone({
      setHeaders: {
        Authorization: `Bearer ${this.us.authToken}`,
      },
      withCredentials: true,
    });

    return next
      .handle(request)
      .pipe(catchError((x) => this.handleAuthError(x)));
  }

  private handleAuthError(err: HttpErrorResponse): Observable<any> {
    if (err.status === 401 || err.status === 403) {
      Utils.showSpinner(false);
      localStorage.removeItem('token');
      Swal.fire({ text: 'Eseguire login!', icon: 'error' });
      this.router.navigateByUrl(`/login`);
    }
    return throwError(() => err);
  }
}
