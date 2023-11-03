import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UserComponent } from './user.component';
import { UserRoutingModule } from './user-routing.module';
import { UtilsModule } from '../utils/utils.module';
import { ASmartTableModule } from '../utils/modules/a-smart-table/a-smart-table.module';
import { IspezioniModule } from './ispezioni/ispezioni.module';
import { NotificheModule } from './notifiche/notifiche.module';
import { SanzioniModule } from './sanzioni/sanzioni.module';
import { DashboardComponent } from './dashboard/dashboard.component';



@NgModule({
  declarations: [
    UserComponent,
    DashboardComponent
  ],
  imports: [
    CommonModule,
    UserRoutingModule,
    IspezioniModule,
    NotificheModule,
    SanzioniModule
  ],
  exports: [
    UserRoutingModule,
  ]
})
export class UserModule { }
