import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { UserRoutingModule } from './user-routing.module';
import { UserDashboardComponent } from './user-dashboard/user-dashboard.component';
import { UserService } from './user.service';
import { UserComponent } from './user.component';
import { UserNoticesComponent } from './user-notices/user-notices.component';
import { ReactiveFormsModule } from '@angular/forms';
import { AnagraficaModule } from '../anagrafica/anagrafica.module';
import { UtilsModule } from '../utils/utils.module';
import { VerbaliModule } from '../verbali/verbali.module';
import { ASmartTableModule } from '../utils/modules/a-smart-table/a-smart-table.module';
import { ADataDeckModule } from '../utils/modules/a-data-deck/a-data-deck.module';


@NgModule({
  declarations: [
    UserDashboardComponent,
    UserComponent,
    UserNoticesComponent,
  ],
  imports: [
    CommonModule,
    UserRoutingModule,
    ReactiveFormsModule,
    AnagraficaModule,
    VerbaliModule,
    UtilsModule,
    ASmartTableModule,
    ADataDeckModule
  ],
  providers: [UserService]
})
export class UserModule { }
