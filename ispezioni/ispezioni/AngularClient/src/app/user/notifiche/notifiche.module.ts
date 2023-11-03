import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { NotificheRoutingModule } from './notifiche-routing.module';
import { ListaNotificheComponent } from './lista-notifiche/lista-notifiche.component';
import { NotificheComponent } from './notifiche.component';
import { NotificheService } from './notifiche.service';
import { ASmartTableModule } from 'src/app/utils/modules/a-smart-table/a-smart-table.module';
import { UtilsModule } from 'src/app/utils/utils.module';
import { ADataDeckModule } from 'src/app/utils/modules/a-data-deck/a-data-deck.module';
import { NotificaComponent } from './notifica/notifica.component';
import { ReactiveFormsModule } from '@angular/forms';


@NgModule({
  declarations: [
    NotificheComponent,
    ListaNotificheComponent,
    NotificaComponent
  ],
  imports: [
    CommonModule,
    NotificheRoutingModule,
    ReactiveFormsModule,
    UtilsModule,
    ASmartTableModule,
    ADataDeckModule,
  ],
  exports: [
    NotificheRoutingModule
  ],
  providers: [
    NotificheService
  ]
})
export class NotificheModule { }
