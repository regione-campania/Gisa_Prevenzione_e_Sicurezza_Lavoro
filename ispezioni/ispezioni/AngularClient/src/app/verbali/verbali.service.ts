import { HttpResponse, HttpClient, HttpHeaders, JsonpInterceptor } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Observable } from 'rxjs';
import { environment } from './../../environments/environment';

@Injectable()
export class VerbaliService {

  constructor(private http: HttpClient, private fb: FormBuilder) {}

  /** Ritorna un FormGroup con {nome, cognome} */
  getFormNomeCognome() {
    return this.fb.group({
      nome: this.fb.control(''),
      cognome: this.fb.control(''),
    })
  }

  /** Ritorna un FormGroup con le generalità di un individuo richieste da più verbali. */
  getFormGeneralità() {
    return this.fb.group({
      nome: this.fb.control(''),
      cognome: this.fb.control(''),
      luogo_nascita: this.fb.control(''),
      data_nascita: this.fb.control(''),
      residenza: this.fb.control(''),
      ruolo: this.fb.control(''),
      telefono: this.fb.control(''),
      tipo_documento: this.fb.control(''),
      numero_documento: this.fb.control(''),
      ente_rilascio_documento: this.fb.control(''),
      data_rilascio_documento: this.fb.control(''),
      data_scadenza_documento: this.fb.control(''),
    })
  }

  getJsonVerbale(idVerbale: number | string) {
    return this.http.get<any>(`http://${environment.host}:${environment.port}/verbali/getJsonVerbale`, {
      params: {idVerbale: idVerbale}
    })
  }

  setJsonVerbale(json: any, idVerbale: any, idModulo: any, idIspezioneFase: any){
    return this.http.post<any>(`http://${environment.host}:${environment.port}/verbali/setJsonVerbale`, {
      verbale: json,
      idVerbale: idVerbale,
      idModulo: idModulo,
      idIspezioneFase: idIspezioneFase
    })
  }

  //per ora permette di scaricare soltanto Verbale di Sopralluogo
  // OLD
  downloadVerbale(data: any, idFase: any): Observable<Blob> {
    return this.http.request<any>('POST', `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/verbali/getVerbaleCompilato?idIspezioneFase=${idFase}`,
      { body: data, responseType: 'blob' as 'json'})
  }

  // Scarica Allegato
  downloadVerbaleBiancoCompilato(idModulo: any, idIspezioneFase: any, idAllegato: any): Observable<HttpResponse<Blob>> {
    return this.http.request<any>('POST', `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/verbali/getVerbaleBiancoCompilato?idModulo=${idModulo}&idIspezioneFase=${idIspezioneFase}&idAllegato=${idAllegato}`,
      { observe: 'response', responseType: 'blob' as 'json'})
  }

  scaricaRicevutaRT(idPagamento: any): Observable<HttpResponse<Blob>> {
    return this.http.request<any>('POST', `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/sanzioni/downloadRicevutaRT?idPagamento=${idPagamento}`,
      { observe: 'response', responseType: 'blob' as 'json'})
  }

  scaricaAvviso(idPagamento: any): Observable<HttpResponse<Blob>> {
    return this.http.request<any>('POST', `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/sanzioni/downloadAvviso?idPagamento=${idPagamento}`,
      { observe: 'response', responseType: 'blob' as 'json'})
  }

  deleteVerbale(idVerbale: any) {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/verbali/deleteVerbale`, {
      params: {idVerbale: idVerbale}
    })
  }

  // Riapri Fase
  deleteVerbaleBianco(idModulo: any, idIspezioneFase: any, idAllegato: any) {
    return this.http.get(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/verbali/deleteVerbaleBianco`, {
      params: {idModulo: idModulo, idIspezioneFase: idIspezioneFase, idAllegato: idAllegato}
    })
  }

  allegaVerbaleCompleto(file: File, idVerbale: any): Observable<any>{
    console.log(file);
    console.log(idVerbale);
    const formData = new FormData();
    formData.append("file", file, file.name);
    return this.http.post(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/verbali/allegaVerbaleCompleto?idVerbale=${idVerbale}`,
        formData
      )
  }

  allegaVerbaleBiancoCompleto(file: File, idModulo: any, idIspezioneFase: any): Observable<any>{
    console.log(file);
    console.log(idModulo);
    const formData = new FormData();
    formData.append("file", file, file.name);
    return this.http.post(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/verbali/allegaVerbaleBianco?idModulo=${idModulo}&idIspezioneFase=${idIspezioneFase}`,
        formData
      )
  }

  getVerbaleBianco(idModulo: any, idIspezioneFase: any, idIspezione: any, formato: any): Observable<HttpResponse<Blob>> {
    return this.http.request<any>('POST', `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/verbali/getVerbaleBianco?idModulo=${idModulo}&idIspezioneFase=${idIspezioneFase}&idIspezione=${idIspezione}&formato=${formato}`,
      { observe: 'response', responseType: 'blob' as 'json'})
  }

  
}
