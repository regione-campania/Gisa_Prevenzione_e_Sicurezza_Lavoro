import { Component } from '@angular/core';
import { NotificationService } from './notification.service';

@Component({
  selector: 'app-notification',
  templateUrl: './notification.component.html',
  styleUrls: ['./notification.component.scss'],
})
export class NotificationComponent {

  constructor(private notificationService: NotificationService) {}

  closeNotification(index: number) {
    this.notificationService.removeAt(index);
  }

  get notifications() {
    return this.notificationService.notifications;
  }

}
