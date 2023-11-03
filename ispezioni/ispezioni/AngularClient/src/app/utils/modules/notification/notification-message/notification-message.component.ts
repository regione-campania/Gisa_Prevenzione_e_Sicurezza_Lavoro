import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { Notification } from '../notification';

@Component({
  selector: 'notification-message',
  templateUrl: './notification-message.component.html',
  styleUrls: ['./notification-message.component.scss'],
})
export class NotificationMessageComponent implements Notification {
  @Input() content = '';
  @Input() delay = 3000;
  @Input('class') notificationClass: 'info' | 'success' | 'error' | 'warning' = 'info';
  @Output('onClose') closeEvent = new EventEmitter();
}
