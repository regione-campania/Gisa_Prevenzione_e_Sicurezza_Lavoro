import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from './../../environments/environment';
import { User } from './user.interface';

@Injectable({
  providedIn: 'root',
})
export class UserService {

  constructor(private http: HttpClient) {}

  findUser(params: any) {
    return this.http.post<any>(
      `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/um/loginByCf`,
      params
    );
  }

  //accessors
  get user() {
    return this.http.get<User>(
      `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/um/getUser`
    );
  }

  get cookieAccepted(): string {
    return localStorage.getItem('cookieAccepted') || 'false';
  }

  set cookieAccepted(value: string) {
    localStorage.setItem('cookieAccepted', value);
  }

  get authToken() {
    return localStorage.getItem('token') ?? '';
  }
}
