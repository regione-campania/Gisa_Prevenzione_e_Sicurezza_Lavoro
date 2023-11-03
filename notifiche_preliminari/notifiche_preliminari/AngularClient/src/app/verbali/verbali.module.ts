import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';
import { VerbaleDiSopralluogoComponent } from './verbale-di-sopralluogo/verbale-di-sopralluogo.component';
import { VerbaliService } from './verbali.service';
import { NotificaComponent } from './notifica/notifica.component';
import { UtilsModule } from '../utils/utils.module';
import { AnagraficaModule } from '../anagrafica/anagrafica.module';
import { NgbDropdownModule } from '@ng-bootstrap/ng-bootstrap';
import { ASmartTableModule } from '../utils/modules/a-smart-table/a-smart-table.module';
import { SanzioneComponent } from './sanzione/sanzione.component';


@NgModule({
  declarations: [
    VerbaleDiSopralluogoComponent,
    NotificaComponent,
    SanzioneComponent
  ],
  imports: [
    CommonModule,
    ReactiveFormsModule,
    UtilsModule,
    AnagraficaModule,
    NgbDropdownModule,
    ASmartTableModule
  ],
  providers: [VerbaliService],
  exports: [
    NotificaComponent,
    SanzioneComponent
  ]
})
export class VerbaliModule { }
