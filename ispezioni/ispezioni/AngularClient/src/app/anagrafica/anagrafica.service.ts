import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from './../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class AnagraficaService {

  constructor(private http: HttpClient) {}

  getAsl() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getAsl`)
  }

  getServizi() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getServizi`)
  }

  getComuni() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getComuni`)
  }

  getComuniCantiere() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getComuniCantiere`)
  }

  getImprese() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getImprese`)
  }

  getSoggettiFisici() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getSoggettiFisici`)
  }

  getEntiUnitaOperative() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getEntiUnitaOperative`)
  }

  getEntiUnitaOperativeTree() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getEntiUnitaOperativeTree`)
  }

  getImpreseSedi() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getImpreseSedi`)
  }

  getStatiNotifica() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getStatiNotifica`)
  }

  getNatureOpera() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getNatureOpera`)
  }

  getDominiPec() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getDominiPec`)
  }

  getRuoliNotifica() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getRuoliNotifica`)
  }

  getEsitiChisuraIspezione() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/anagrafiche/getEsitiChisuraIspezione`)
  }

}
