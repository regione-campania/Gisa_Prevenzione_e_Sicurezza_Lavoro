import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ListaNotificheComponent } from './lista-notifiche/lista-notifiche.component';
import { NotificaComponent } from './notifica/notifica.component';
import { NotificheComponent } from './notifiche.component';

const routes: Routes = [
  {
    path: 'notifiche',
    component: NotificheComponent,
    children: [
      { path: '', component: ListaNotificheComponent },
      { path: 'notifica', component: NotificaComponent },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class NotificheRoutingModule {}
