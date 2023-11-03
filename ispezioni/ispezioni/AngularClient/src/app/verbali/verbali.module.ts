import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';
import { VerbaleDiSopralluogoComponent } from './verbale-di-sopralluogo/verbale-di-sopralluogo.component';
import { VerbaliService } from './verbali.service';
import { UtilsModule } from '../utils/utils.module';
import { NgbDropdownModule } from '@ng-bootstrap/ng-bootstrap';
import { ASmartTableModule } from '../utils/modules/a-smart-table/a-smart-table.module';
import { AFormModule } from 'src/app/forms/a-form.module';
import { VerbaleDiAccertamentoComponent } from './verbale-di-accertamento/verbale-di-accertamento.component';
import { RichiestaDocumentaleAziendeComponent } from './richiesta-documentale-aziende/richiesta-documentale-aziende.component';
import { RichiestaDocumentaleCantieriComponent } from './richiesta-documentale-cantieri/richiesta-documentale-cantieri.component';
import { VerbaleDiPrescrizioneComponent } from './verbale-di-prescrizione/verbale-di-prescrizione.component';
import { VerbaleDiPrescrizioneEContestualeAccertamentoComponent } from './verbale-di-prescrizione-e-contestuale-accertamento/verbale-di-prescrizione-e-contestuale-accertamento.component';
import { VerbaliComponent } from './verbali.component';
import { VerbaleSequestroPreventivoComponent } from './verbale-sequestro-preventivo/verbale-sequestro-preventivo.component';
import { VerbaleSequestroProbatorioComponent } from './verbale-sequestro-probatorio/verbale-sequestro-probatorio.component';
import { VerbaleDiSommarieInformazioniTestimonialiComponent } from './verbale-di-sommarie-informazioni-testimoniali/verbale-di-sommarie-informazioni-testimoniali.component';
import { VerbaleDiSpontaneeDichiarazioniComponent } from './verbale-di-spontanee-dichiarazioni/verbale-di-spontanee-dichiarazioni.component';


@NgModule({
  declarations: [
    VerbaliComponent,
    VerbaleDiSopralluogoComponent,
    RichiestaDocumentaleAziendeComponent,
    RichiestaDocumentaleCantieriComponent,
    VerbaleDiPrescrizioneComponent,
    VerbaleDiAccertamentoComponent,
    VerbaleDiPrescrizioneEContestualeAccertamentoComponent,
    VerbaleSequestroPreventivoComponent,
    VerbaleSequestroProbatorioComponent,
    VerbaleDiSommarieInformazioniTestimonialiComponent,
    VerbaleDiSpontaneeDichiarazioniComponent,
  ],
  imports: [
    CommonModule,
    ReactiveFormsModule,
    UtilsModule,
    NgbDropdownModule,
    ASmartTableModule,
    AFormModule
  ],
  providers: [
    VerbaliService,
  ],
  exports: [
    VerbaliComponent
  ]
})
export class VerbaliModule { }
