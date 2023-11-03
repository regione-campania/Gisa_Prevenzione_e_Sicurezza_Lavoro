import { Component, OnInit } from '@angular/core';
import { Verbale } from '../verbale.abstract';

@Component({
  selector: 'verbale-di-prescrizione-e-contestuale-accertamento',
  templateUrl: './verbale-di-prescrizione-e-contestuale-accertamento.component.html',
  styleUrls: ['./verbale-di-prescrizione-e-contestuale-accertamento.component.scss']
})
export class VerbaleDiPrescrizioneEContestualeAccertamentoComponent extends Verbale {
  //override idModulo = 5;

  override idModulo = 15;

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
    termine_prescrizione: '',
    dovra_provvedere: '',
    importo_da_pagare: '',
  });
}
