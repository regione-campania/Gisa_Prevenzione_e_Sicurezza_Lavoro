import { Component, OnInit } from '@angular/core';
import { Verbale } from '../verbale.abstract';

@Component({
  selector: 'app-verbale-di-sommarie-informazioni-testimoniali',
  templateUrl: './verbale-di-sommarie-informazioni-testimoniali.component.html',
  styleUrls: ['./verbale-di-sommarie-informazioni-testimoniali.component.scss']
})
export class VerbaleDiSommarieInformazioniTestimonialiComponent extends Verbale {
  //override idModulo = 8;
  override idModulo = 18;

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
    domanda: '',
    risposta: '',
    ora_firma: '',
  });

}
