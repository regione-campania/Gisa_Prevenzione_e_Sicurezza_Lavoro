import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from './../../environments/environment';

@Injectable()
export class AnagraficaService {

  constructor(private http: HttpClient) {}

  getComuni() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}/anagrafiche/getComuni`)
  }

  getComuniCantiere() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}/anagrafiche/getComuniCantiere`)
  }

  getImprese() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}/anagrafiche/getImprese`)
  }

  getSoggettiFisici() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}/anagrafiche/getSoggettiFisici`)
  }

  getEntiUnitaOperative() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}/anagrafiche/getEntiUnitaOperative`)
  }

  getEntiUnitaOperativeTree() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}/anagrafiche/getEntiUnitaOperativeTree`)
  }

  getImpreseSedi() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}/anagrafiche/getImpreseSedi`)
  }

  getStatiNotifica() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}/anagrafiche/getStatiNotifica`)
  }

  getDominiPec() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}/anagrafiche/getDominiPec`)
  }

}
