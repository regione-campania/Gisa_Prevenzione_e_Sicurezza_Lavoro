import { Component, OnInit } from '@angular/core';
import { Verbale } from '../verbale.abstract';

@Component({
  selector: 'verbale-di-accertamento',
  templateUrl: './verbale-di-accertamento.component.html',
  styleUrls: ['./verbale-di-accertamento.component.scss']
})
export class VerbaleDiAccertamentoComponent extends Verbale {
  //override idModulo = 4;
  override idModulo = 14;

  override form = this.fb.group({
    proc_pen: '',
    rgnr: '',
    upg1: '',
    upg2: '',
    congiuntamente_a: '',
    ufficio: '',
    data_fase: '',
    presso: '',
    presenza_di: '',
    nato_a: '',
    data_nascita: '',
    residente_a: '',
    in_qualita_di: '',
    telefono: '',
    email: '',
    identificato_con: '',
    numero_documento: '',
    rilasciato_da: '',
    data_rilascio: '',
    data_scadenza: '',
    data_verbale_prescrizione: '',
    ottemperanza: '',
    art_1: '',
    in_quanto_1: '',
    art_2: '',
    in_quanto_2: '',
    art_3: '',
    in_quanto_3: '',
    contravventore: '',
    importo: '',
  });

  get ottemperanzaValue() {
    return this.form.get('ottemperanza')!.value;
  }


}
