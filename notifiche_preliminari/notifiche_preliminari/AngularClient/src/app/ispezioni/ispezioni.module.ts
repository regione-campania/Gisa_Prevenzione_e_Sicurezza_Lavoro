import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IspezioniRoutingModule } from './ispezioni-routing.module';
import { IspezioniComponent } from './ispezioni.component';
import { ListaIspezioniComponent } from './lista-ispezioni/lista-ispezioni.component';
import { ListaMacchinariComponent } from './lista-macchinari/lista-macchinari.component';
import { IspezioniService } from './ispezioni.service';
import { UtilsModule } from '../utils/utils.module';
import { AFormModule } from '../utils/modules/a-form/a-form.module';
import { AnagraficaModule } from '../anagrafica/anagrafica.module';
import { NuovaIspezioneComponent } from './nuova-ispezione/nuova-ispezione.component';
import { ASmartTableModule } from '../utils/modules/a-smart-table/a-smart-table.module';
import { VerbaliModule } from '../verbali/verbali.module';


@NgModule({
  declarations: [
    IspezioniComponent,
    ListaIspezioniComponent,
    ListaMacchinariComponent,
    NuovaIspezioneComponent
  ],
  imports: [
    CommonModule,
    IspezioniRoutingModule,
    AnagraficaModule,
    UtilsModule,
    ASmartTableModule,
    AFormModule,
    VerbaliModule
  ],
  providers: [
    IspezioniService
  ]
})
export class IspezioniModule { }
