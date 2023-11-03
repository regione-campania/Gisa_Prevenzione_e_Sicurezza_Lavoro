import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { map, Observable } from 'rxjs';
import { baseUri } from 'src/environments/environment';
import { BackendResponse } from '../../lib';

@Injectable({
  providedIn: 'root',
})
export class BackendCommunicationService {
  constructor(private http: HttpClient) {}

  getDati(functionName: string, args: any = {}): Observable<BackendResponse> {
    return this.http
      .get(baseUri + 'api/getDati', {
        params: { function: functionName, args: JSON.stringify(args) },
      })
      .pipe(
        map((res: any) => {
          console.log(`--- get_dati('${functionName}') response: `, res);
          if(res === null) res = {esito: false, value: null, msg: null, info: false};
          if(res.info === null) res.info = res.esito;
          else res.info = JSON.parse(res.info);
          return res;
        })
      );
  }

  updDati(functionName: string, args: any = {}): Observable<BackendResponse> {
    return this.http
      .post(baseUri + 'api/updDati', {
        function: functionName,
        args: JSON.stringify(args),
      })
      .pipe(
        map((res: any) => {
          console.log(`--- upd_dati('${functionName}') response: `, res);
          if(res === null) res = {esito: false, value: null, msg: null, info: false};
          if(res.info === null) res.info = res.esito;
          else res.info = JSON.parse(res.info);
          return res;
        })
      );
  }
}
