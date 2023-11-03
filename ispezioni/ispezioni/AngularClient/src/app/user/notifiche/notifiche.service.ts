import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';

@Injectable()
export class NotificheService {

  constructor(private http: HttpClient) {
  }

  getNotifiche() {
    return this.http.get<any>(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/notifiche/getNotifiche`, {
      //params: {idNotificante: this.userId, ruolo: this.userRole, site_id: this.userIdAsl}
    })
  }

  getNotificaInfo(id: number | string) {
    return this.http.get<any>(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/notifiche/getNotificaInfo`, {
      params: {idNotifica: id, /*idNotificante: this.userId*/}
    })
  }

  insertNotifica() {
    return this.http.post<any>(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/notifiche/insertNotifica`, {
      //id_soggetto_notificante: this.user.id
    })
  }

  updateNotifica(notifica: any) {
    return this.http.post<any>(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/notifiche/updateNotificaInfo`, {
      notifica: notifica
    })
  }

  checkNotifica(notifica: any) {
    return this.http.post<any>(`${environment.protocol}://${environment.host}:${environment.port}${environment.path}/notifiche/checkNotifica`, {
      notifica: notifica
    })
  }

  downloadNotifica(notifica: any, nuovoPdf: boolean, tipoDocumento: any): Observable<Blob> {
    return this.http.request<any>('POST', `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/verbali/getNotificaCompilata?descrizioneVerbale=${tipoDocumento}&nuovoPdf=${nuovoPdf}`,
      { body: notifica, responseType: 'blob' as 'json'})
  }
}
