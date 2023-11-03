import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SanzioneComponent } from './sanzione/sanzione.component';
import { SanzioniComponent } from './sanzioni.component';
import { SanzioniService } from './sanzioni.service';
import { UtilsModule } from 'src/app/utils/utils.module';
import { ASmartTableModule } from 'src/app/utils/modules/a-smart-table/a-smart-table.module';
import { ADataDeckModule } from 'src/app/utils/modules/a-data-deck/a-data-deck.module';
import { ReactiveFormsModule } from '@angular/forms';
import { AFormModule } from 'src/app/forms/a-form.module';
import { ListaSanzioniDaAllegareComponent } from './lista-sanzioni-da-allegare/lista-sanzioni-da-allegare.component';
import { SanzioniRoutingModule } from './sanzioni-routing.module';



@NgModule({
  declarations: [
    SanzioniComponent,
    SanzioneComponent,
    ListaSanzioniDaAllegareComponent
  ],
  imports: [
    CommonModule,
    SanzioniRoutingModule,
    ReactiveFormsModule,
    AFormModule,
    UtilsModule,
    ASmartTableModule,
    ADataDeckModule
  ],
  providers: [
    SanzioniService,
  ],
  exports: [
    SanzioniRoutingModule,
    SanzioneComponent,
    ListaSanzioniDaAllegareComponent
  ]
})
export class SanzioniModule { }
