import { HttpClient, JsonpInterceptor } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';

@Injectable()
export class SanzioniService {

  constructor(private http: HttpClient) {}

  insertSanzione(data: any) {
    return this.http.post(
      `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/sanzioni/insertSanzione`,
      data
    );
  }

  getSanzione(idIspezioneFase: string | number) {
    return this.http.get(
      `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/sanzioni/getSanzioneInfo`,
      {
        params: { idIspezioneFase: idIspezioneFase },
      }
    );
  }

  getSanzioniDaAllegare() {
    return this.http.get(
      `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/sanzioni/getSanzioniDaAllegare`);
  }

  allegaSanzione(
    idIspezioneFase: string | number,
    idPagamento: string | number
  ) {
    return this.http.get(
      `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/sanzioni/allegaSanzione`,
      {
        params: { idIspezioneFase: idIspezioneFase, idPagamento: idPagamento },
      }
    );
  }

  annullaSanzione(idIspezioneFase: string | number) {
    return this.http.get(
      `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/sanzioni/annullaSanzione`,
      {
        params: { idIspezioneFase: idIspezioneFase },
      }
    );
  }

  annullaPagamento(idPagamento: string | number) {
    return this.http.get(
      `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/sanzioni/annullaSanzione`,
      {
        params: { idPagamento: idPagamento },
      }
    );
  }

  modificaDataNotifica(idPagamento: string | number, nuovaDataNotifica: string, tipoNotifica: string, changeNotifica: boolean) {
    return this.http.get(
      `${environment.protocol}://${environment.host}:${environment.port}${environment.path}/sanzioni/modificaDataNotifica`,
      {
        params: { idPagamento: idPagamento, dataNotifica: nuovaDataNotifica, tipoNotifica: tipoNotifica, changeNotifica: changeNotifica },
      }
    );  
  }
}
