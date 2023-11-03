import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';
import { UtilsModule } from '../../utils.module';
import { AFormFactory } from './a-form-factory.service';
import { FormFaseIspezioneComponent } from './forms-prototypes/form-fase-ispezione/form-fase-ispezione.component';
import { FormIspezioneComponent } from './forms-prototypes/form-ispezione/form-ispezione.component';
import { FormCantiereComponent } from './forms-prototypes/form-cantiere/form-cantiere.component';
import { FormRicercaCantiereComponent } from './forms-prototypes/form-ricerca-cantiere/form-ricerca-cantiere.component';
import { FormRicercaImpresaComponent } from './forms-prototypes/form-ricerca-impresa/form-ricerca-impresa.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { BrowserModule } from '@angular/platform-browser';
import { ASmartTableModule } from '../a-smart-table/a-smart-table.module';



@NgModule({
  declarations: [
    FormIspezioneComponent,
    FormFaseIspezioneComponent,
    FormCantiereComponent,
    FormRicercaCantiereComponent,
    FormRicercaImpresaComponent
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
    AFormFactory
  ],
  exports: [
    FormIspezioneComponent,
    FormFaseIspezioneComponent,
    FormCantiereComponent,
    FormRicercaCantiereComponent,
    FormRicercaImpresaComponent
  ]
})
export class AFormModule { }
