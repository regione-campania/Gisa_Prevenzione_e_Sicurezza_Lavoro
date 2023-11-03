import { Component, OnInit } from '@angular/core';
import { Verbale } from '../verbale.abstract';

@Component({
  selector: 'app-verbale-sequestro-preventivo',
  templateUrl: './verbale-sequestro-preventivo.component.html',
  styleUrls: ['./verbale-sequestro-preventivo.component.scss'],
})
export class VerbaleSequestroPreventivoComponent extends Verbale {
  /* override idModulo = 6; */
  override idModulo = 16;

  override form = this.fb.group({
    proc_pen: '',
    rgnr: '',
    a_carico_di: this.fb.group({
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
    upg1: '',
    upg2: '',
    congiuntamente_a: '',
    ufficio: '',
    il_giorno: '',
    alla_presenza_di: this.fb.group({
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
    azienda_o_cantiere: 'azienda',
    azienda: this.fb.group({
      rag_sociale: '',
      comune: '',
      via: '',
      sede_legale: '',
    }),
    cantiere: this.fb.group({
      nome: '',
      comune: '',
      via: '',
      impresa: '',
      sede_legale: '',
      rappresentante_legale: this.fb.group({
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
    }),
    note_sequestro: '',
    n_cartelli: 0,
    n_sigilli: 0,
    testo_libero: this.fb.group({
      la_le: '',
      costituite_da: '',
    }),
    custode_giudiziario: this.fb.group({
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
      domicilio_notifica_atti: ''
    }),
    verbale_consegnato_a: '',
    tribunale: '',
  });
}
