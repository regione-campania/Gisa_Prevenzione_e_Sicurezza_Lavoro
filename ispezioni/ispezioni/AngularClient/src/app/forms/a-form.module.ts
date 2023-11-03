import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';
import { UtilsModule } from '../utils/utils.module';
import { AFormFactoryService } from './a-form-factory.service';
import { FormFaseIspezioneComponent } from './forms-prototypes/form-fase-ispezione/form-fase-ispezione.component';
import { FormIspezioneComponent } from './forms-prototypes/form-ispezione/form-ispezione.component';
import { FormCantiereComponent } from './forms-prototypes/form-cantiere/form-cantiere.component';
import { FormRicercaCantiereComponent } from './forms-prototypes/form-ricerca-cantiere/form-ricerca-cantiere.component';
import { FormRicercaImpresaComponent } from './forms-prototypes/form-ricerca-impresa/form-ricerca-impresa.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { BrowserModule } from '@angular/platform-browser';
import { ASmartTableModule } from '../utils/modules/a-smart-table/a-smart-table.module';
import { AFormService } from './a-form-service';
import { FormSoggettoPagatoreComponent } from './forms-prototypes/form-soggetto-pagatore/form-soggetto-pagatore.component';



@NgModule({
  declarations: [
    FormIspezioneComponent,
    FormFaseIspezioneComponent,
    FormCantiereComponent,
    FormRicercaCantiereComponent,
    FormRicercaImpresaComponent,
    FormSoggettoPagatoreComponent
  ],
  imports: [
    CommonModule,
    ReactiveFormsModule,
    BrowserModule,
    BrowserAnimationsModule,
    UtilsModule,
    ASmartTableModule
  ],
  providers: [
    AFormFactoryService,
    AFormService
  ],
  exports: [
    FormIspezioneComponent,
    FormFaseIspezioneComponent,
    FormCantiereComponent,
    FormRicercaCantiereComponent,
    FormRicercaImpresaComponent,
    FormSoggettoPagatoreComponent
  ]
})
export class AFormModule { }
