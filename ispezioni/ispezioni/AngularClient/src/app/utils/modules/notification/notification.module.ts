import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NotificationMessageComponent } from './notification-message/notification-message.component';
import { NotificationComponent } from './notification.component';
import { NotificationService } from './notification.service';



@NgModule({
  declarations: [
    NotificationMessageComponent,
    NotificationComponent
  ],
  imports: [
    CommonModule
  ],
  exports: [
    NotificationComponent
  ],
  providers: [
    NotificationService
  ]
})
export class NotificationModule { }
