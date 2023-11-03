import { Component, OnInit } from '@angular/core';
import { Verbale } from '../verbale.abstract';

@Component({
  selector: 'richiesta-documentale-cantieri',
  templateUrl: './richiesta-documentale-cantieri.component.html',
  styleUrls: ['./richiesta-documentale-cantieri.component.scss']
})
export class RichiestaDocumentaleCantieriComponent extends Verbale {
  /* override idModulo = 2; */
  override idModulo = 12;

  override form = this.fb.group({
    data: '',
    upg1: '',
    upg2: '',
    congiuntamente_a: '',
    ufficio: '',
    ispezione: this.fb.group({
      cantiere: this.fb.group({
        nome: '',
        attivita: '',
        comune: '',
        via: '',
      }),
      azienda: this.fb.group({
        rag_sociale: '',
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
      all_atto_del_sopralluogo: this.fb.group({
        cantiere_1: '',
        impresa_1: '',
        attivita_1: '',
        cantiere_2: '',
        impresa_2: '',
        attivita_2: '',
        cantiere_3: '',
        impresa_3: '',
        attivita_3: '',
        note: '',
      }),
      in_fase_ispettiva: ''
    }),
    documentazione_richiesta: this.fb.group({
      notifica_preliminare: '',
      identificazione_responsabili: '',
      psc: '',
      cronoprogramma_lavori: '',
      pee: '',
      fascicolo_opera: '',
      stima_costi: '',
      verbale_apertura_et_altri: '',
      contratti_con_imprese: '',
      lavoratori_autonomi: '',
      ppoos: '',
      pimus: '',
      conformita_impianto_elettrico: '',
      cpi_gasolio: '',
      presenze_giornaliere: '',
      altra_documentazione_utile: '',
      specifica_altra_documentazione: '',
      certificato_cciaa: '',
      durc: '',
      individuazione_datore_lavoro: '',
      igiene_e_sicurezza: '',
      rspp: '',
      medico_competente: '',
      protocollo_sanitario: '',
      verbale_di_elezione: '',
      pos: '',
      valutazione_rischi: '',
      organigramma_aziendale: '',
      verbale_ultima_riunione_periodica: '',
      unilav: '',
      giudizio_idoneità: '',
      attestati_salute_e_sicurezza: '',
      consegna_dpi: '',
      addetti_antincendio_e_primo_soccorso: '',
      attrezzature_macchine_impianti: '',
      eventuale_subappalto: '',
      altra_documentazione_utile_2: '',
      specifica_altra_documentazione_2: '',
      data_consegna_documentazione: '',
      ora_consegna_documentazione: '',
    }),
  })
}
