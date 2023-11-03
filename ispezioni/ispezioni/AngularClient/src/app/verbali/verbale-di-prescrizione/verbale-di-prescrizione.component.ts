import { Component } from '@angular/core';
import { Verbale } from '../verbale.abstract';

@Component({
  selector: 'verbale-di-prescrizione',
  templateUrl: './verbale-di-prescrizione.component.html',
  styleUrls: ['./verbale-di-prescrizione.component.scss'],
})
export class VerbaleDiPrescrizioneComponent extends Verbale {
  //override idModulo = 3;
  override idModulo = 13;

  override form = this.fb.group({
    proc_pen: '',
    rgnr: '',
    upg1: '',
    upg2: '',
    congiuntamente_a: '',
    ufficio: '',
    data_fase: '',
    presso: '',
    art_1: '',
    in_quanto_1: '',
    art_2: '',
    in_quanto_2: '',
    art_3: '',
    in_quanto_3: '',
    contravventore: this.fb.group({
      nominativo: '',
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
    }),
    prescrizioni: this.fb.group({
      punto_1: '',
      punto_2: '',
      punto_3: '',
      tempo_massimo: '',
    }),
  });
}
