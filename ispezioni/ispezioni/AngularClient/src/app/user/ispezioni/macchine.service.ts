import { Injectable } from '@angular/core';
import { HttpResponse, HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MacchineService {

  constructor(private http: HttpClient) { }

  getCostruttori() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/macchine/getCostruttori`);
  }

  getMacchine() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/macchine/getMacchine`)
  }

  getTipiMacchine() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/macchine/getTipiMacchine`);
  }

  eliminaInfoFile(idMacchina: any) {
    return this.http.request<any>('POST', `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/macchine/eliminaInfoFile?idMacchina=${idMacchina}`);
  }

  downloadInfoFile(idMacchina: any): Observable<HttpResponse<Blob>> {
    return this.http.request<any>('POST', `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/macchine/downloadInfoFile?idMacchina=${idMacchina}`,
      { observe: 'response', responseType: 'blob' as 'json'})
  }

  updMacchine(macchina: any, file: File, filename: string) {
    const formData = new FormData();
    formData.append("file", file, file.name);
    return this.http.post(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/macchine/updMacchine?macchina=${macchina}&filename=${filename}`,
      formData
    )
  }
}
