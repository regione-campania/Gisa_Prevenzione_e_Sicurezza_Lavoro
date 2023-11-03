import { Component, OnInit } from '@angular/core';
import { Verbale } from '../verbale.abstract';

@Component({
  selector: 'app-verbale-di-spontanee-dichiarazioni',
  templateUrl: './verbale-di-spontanee-dichiarazioni.component.html',
  styleUrls: ['./verbale-di-spontanee-dichiarazioni.component.scss'],
})
export class VerbaleDiSpontaneeDichiarazioniComponent extends Verbale {
  //override idModulo = 9;
  override idModulo = 19;

  override form = this.fb.group({
    il_giorno: '',
    alle_ore: '',
    in: '',
    presso_ufficio: '',
    upg: '',
    tdp: '',
    in_relazione: '',
    pm: '',
    testimoniante: this.fb.group({
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
    dichiarazioni: '',
    ora_firma: '',
  });
}
