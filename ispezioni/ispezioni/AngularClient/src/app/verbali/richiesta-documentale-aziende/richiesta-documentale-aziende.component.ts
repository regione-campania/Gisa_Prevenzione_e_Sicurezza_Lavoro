import { Component, OnInit } from '@angular/core';
import { Verbale } from '../verbale.abstract';

@Component({
  selector: 'richiesta-documentale-aziende',
  templateUrl: './richiesta-documentale-aziende.component.html',
  styleUrls: ['./richiesta-documentale-aziende.component.scss']
})
export class RichiestaDocumentaleAziendeComponent extends Verbale {
  /* override idModulo = 1; */
  override idModulo = 11;

  override form = this.fb.group({
    data: '',
    upg1: '',
    upg2: '',
    congiuntamente_a: '',
    ufficio: '',
    ispezione: this.fb.group({
      azienda: this.fb.group({
        rag_sociale: '',
        comune: '',
        via: '',
        sede_legale: '',
      }),
      alla_presenza_di: this.fb.group({
        nominativo: '',
        comune_nascita: '',
        data_nascita: '',
        comune_residenza: '',
        in_qualita_di: '',
        telefono: '',
        identificato_con: '',
        numero_documento: '',
        rilasciato_da: '',
        data_rilascio: '',
        data_scadenza: '',
      })
    }),
    descrizione_luoghi_lavoro: this.fb.group({
      all_atto_del_sopralluogo: '',
      in_fase_ispettiva: ''
    }),
    documentazione_richiesta: this.fb.group({
      certificato_cciaa: '',
      durc: '',
      valutazione_rischi: '',
      pee: '',
      organigramma_aziendale: '',
      individuazione_datore_lavoro: '',
      igiene_e_sicurezza: '',
      rspp: '',
      medico_competente: '',
      protocollo_sanitario: '',
      verbale_di_elezione: '',
      verbale_ultima_riunione_periodica: '',
      unilav: '',
      giudizio_idoneità: '',
      attestati_salute_e_sicurezza: '',
      consegna_dpi: '',
      addetti_antincendio_e_primo_soccorso: '',
      attrezzature_macchine_impianti: '',
      conformita_impianto_elettrico: '',
      verifica_impianto_termico: '',
      cpi_gasolio: '',
      contratti_altre_imprese: '',
      altra_documentazione_utile: '',
      specifica_altra_documentazione: '',
      data_consegna_documentazione: '',
      ora_consegna_documentazione: '',
    }),
  })
}
