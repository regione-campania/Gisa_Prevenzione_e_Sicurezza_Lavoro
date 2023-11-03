import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ASmartTableComponent } from './a-smart-table.component';
import { TableControlsModule } from './table-controls/table.controls.module';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { DataManagerModule } from '../../services/data-manager/data-manager.module';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';

@NgModule({
  declarations: [ASmartTableComponent],
  imports: [
    CommonModule,
    TableControlsModule,
    DataManagerModule,
    BrowserModule,
    BrowserAnimationsModule,
    NgbModule
  ],
  exports: [ASmartTableComponent, TableControlsModule],
  providers: [ASmartTableComponent],
})
export class ASmartTableModule {}
