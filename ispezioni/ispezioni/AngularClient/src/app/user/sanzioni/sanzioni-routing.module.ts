import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ListaSanzioniDaAllegareComponent } from './lista-sanzioni-da-allegare/lista-sanzioni-da-allegare.component';
import { SanzioneComponent } from './sanzione/sanzione.component';
import { SanzioniComponent } from './sanzioni.component';

export const routes: Routes = [
  {
    path: 'sanzioni',
    component: SanzioniComponent,
    children: [
      { path: '', component: ListaSanzioniDaAllegareComponent},
      { path: 'nuova-sanzione', component: SanzioneComponent }
    ]
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SanzioniRoutingModule { }
