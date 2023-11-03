import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';

@Injectable()
export class IspezioniService {

  deleteFase(idFase: any) {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/deleteIspezioneFase?idFase=${idFase}`)
  }

  constructor(private http: HttpClient) {
  }

  getIspezioni() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getIspezioni`)
  }

  getNuovaIspezione(idUtente: string | number) {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/insertIspezione`, {
      params: {id_utente: idUtente}
    })
  }

  getNuovaFase(idIspezione: string | number) {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/insertIspezioneFase`, {
      params: {idIspezione: idIspezione}
    })
  }

  updateIspezione(ispezione: any) {
    return this.http.post(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/updateIspezioneInfo`, ispezione)
  }

  getIspezioneInfo(idIspezione: string | number) {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getIspezioneInfo`, {
      params: {idIspezione: idIspezione}
    })
  }

  getFaseInfo(idFase: string | number) {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getIspezioneFasi`, {
      params: {idIspezioneFase: idFase}
    })
  }

  updateFaseInfo(fase: any){
    return this.http.post(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/updateFaseInfo`, fase)
  }

  getEsitiFase(idIspezione: string | number) {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getEsitiFase`, {
      params: {idIspezione: idIspezione}
    })
  }

  getMotiviIspezione() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getMotiviIspezione`)
  }

  getCantieriAttivi() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getCantieriAttivi`)
  }

  getCantiereImpreseSedi(idCantiere: string | number) {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getMacchine`, {
      params: {idCantiere: idCantiere}
    })
  }

  getModuliVerbale() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getModuli`)
  }

  insertVerbaleFase(idModulo: any, idIspezioneFase: any) {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/insertVerbaleFase`, {
      params: {idModulo: idModulo, idIspezioneFase: idIspezioneFase}
    })
  }

  getIspettoriServizio() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getIspettoriServizio`)
  }

  getIspettoriAsl() {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getIspettoriAsl`)
  }

  getIspezioniByIdIspettore(idIspettore: any) {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getIspezioniByIdIspettore`, {
      params: {idIspettore: idIspettore}
    })
  }

  trasferisciIspezioni(idIspettoreDa: any, idIspettoreA: any, idIspezioni: any[]) {
    return this.http.post(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/trasferisciIspezioni`, {
      idIspettoreA: idIspettoreA, idIspettoreDa: idIspettoreDa, idIspezioni: idIspezioni
    })
  }

  insertCantiere(cantiere: any) {
    return this.http.post(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/insertCantiere`, {
      cantiere
    })
  }

  updateCantiere(cantiere: any) {
    return this.http.post(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/updateCantiere`, {
      cantiere
    })
  }

  deleteCantiere(id: number | string) {
    return this.http.get<any>(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/deleteCantiere`, {
      params: {idCantiere: id}
    })
  }

  getCantiereImprese(id: number | string) {
    return this.http.get<any>(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getCantiereImprese`, {
      params: {idCantiere: id}
    })
  }

  getPersoneIspezione(id_cantiere: any) {
    return this.http.get<any>(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/getPersoneIspezione`, {
      params: {idCantiere: id_cantiere}
    })
  }

  closeIspezione(idIspezione: any, idEsitoIspezione?: any) {
    return this.http.get<any>(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/ispezioni/closeIspezione`, {
      params: {idIspezione: idIspezione, idEsitoIspezione: idEsitoIspezione}
    })
  }
}
