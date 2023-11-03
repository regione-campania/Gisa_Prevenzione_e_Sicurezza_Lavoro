import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { IspezioniComponent } from './ispezioni.component';
import { ListaIspezioniComponent } from './lista-ispezioni/lista-ispezioni.component';
import { IspezioneComponent } from './ispezione/ispezione.component';
import { TrasferimentoIspezioniComponent } from './trasferimento-ispezioni/trasferimento-ispezioni.component';
import { MacchineDifformiComponent } from './macchine-difformi/macchine-difformi.component';
import { NuovaMacchinaComponent } from './nuova-macchina/nuova-macchina.component';

export const routes: Routes = [
  {
    path: 'ispezioni',
    component: IspezioniComponent,
    children: [
      {
        path: '',
        children: [
          { path: 'ispezione', component: IspezioneComponent },
          { path: 'nuova-ispezione', component: IspezioneComponent },
          { path: 'trasferimento-ispezioni', component: TrasferimentoIspezioniComponent },
          { path: 'macchine-difformi', component: MacchineDifformiComponent },
          { path: 'nuova-macchina', component: NuovaMacchinaComponent },
          { path: '', component: ListaIspezioniComponent },
        ]
      }
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class IspezioniRoutingModule {}
