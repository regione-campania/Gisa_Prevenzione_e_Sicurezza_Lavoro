import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { IspezioniRoutingModule } from './ispezioni-routing.module';
import { IspezioniComponent } from './ispezioni.component';
import { ListaIspezioniComponent } from './lista-ispezioni/lista-ispezioni.component';
import { IspezioniService } from './ispezioni.service';
import { UtilsModule } from '../../utils/utils.module';
import { AFormModule } from 'src/app/forms/a-form.module';
import { IspezioneComponent } from './ispezione/ispezione.component';
import { ASmartTableModule } from '../../utils/modules/a-smart-table/a-smart-table.module';
import { ADataDeckModule } from 'src/app/utils/modules/a-data-deck/a-data-deck.module';
import { VerbaliModule } from '../../verbali/verbali.module';
import { DettaglioIspezioneComponent } from './dettaglio-ispezione/dettaglio-ispezione.component';
import { SanzioniModule } from '../sanzioni/sanzioni.module';
import { ANavigatorModule } from 'src/app/utils/modules/a-navigator/a-navigator.module';
import { TrasferimentoIspezioniComponent } from './trasferimento-ispezioni/trasferimento-ispezioni.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { MacchineDifformiComponent } from './macchine-difformi/macchine-difformi.component';
import { NuovaMacchinaComponent } from './nuova-macchina/nuova-macchina.component';


@NgModule({
  declarations: [
    IspezioniComponent,
    ListaIspezioniComponent,
    IspezioneComponent,
    DettaglioIspezioneComponent,
    TrasferimentoIspezioniComponent,
    MacchineDifformiComponent,
    NuovaMacchinaComponent
  ],
  imports: [
    CommonModule,
    IspezioniRoutingModule,
    UtilsModule,
    ANavigatorModule,
    ASmartTableModule,
    AFormModule,
    SanzioniModule,
    VerbaliModule,
    ADataDeckModule,
    NgbModule,
    ReactiveFormsModule
  ],
  exports: [
    IspezioniRoutingModule
  ],
  providers: [
    IspezioniService
  ]
})
export class IspezioniModule { }
