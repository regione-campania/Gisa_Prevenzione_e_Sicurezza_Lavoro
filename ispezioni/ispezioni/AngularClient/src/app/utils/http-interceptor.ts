import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
  HttpErrorResponse,
} from '@angular/common/http';
import { catchError, Observable, throwError } from 'rxjs';
import { Router } from '@angular/router';
import { baseUri, environment } from 'src/environments/environment';
import Swal from 'sweetalert2';

@Injectable()
export class TokenInterceptor implements HttpInterceptor {

  constructor(private router: Router) {}

  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {

    /* if (!localStorage.getItem('token')) {
      Swal.fire({
        titleText: 'Eseguire Login!',
        confirmButtonText: 'OK',
      }).then((_) => {
        window.location.href = `${baseUri}login/`;
      });
    } */

    request = request.clone({
      setHeaders: {
        Authorization: 'Bearer ' + localStorage.getItem('token'),
      },
      withCredentials: true,
    });

    return next
      .handle(request)
      .pipe(catchError((x) => this.handleAuthError(x)));

  }

  private handleAuthError(err: HttpErrorResponse): Observable<any> {
    if (err.status === 401 || err.status === 403) {
      console.log('err.status:', err.status);
      localStorage.removeItem('token');
      Swal.fire({
        titleText: 'Eseguire Login!',
        confirmButtonText: 'OK',
      }).then((_) => {
        window.location.href = `${baseUri}login/`;
      });
    }
    return throwError(() => err);
  }
}
