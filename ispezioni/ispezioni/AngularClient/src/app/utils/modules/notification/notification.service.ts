import { EventEmitter, Injectable } from '@angular/core';
import { Notification } from './notification';

@Injectable({
  providedIn: 'root'
})
export class NotificationService {
  private _notifications: Notification[] = [];

  //events
  notificationAdded = new EventEmitter<Notification>();
  notificationRemoved = new EventEmitter<Notification>();

  constructor() { }

  push(notification: Partial<Notification>) {
    let newNotification: Notification = {
      content: notification.content || '',
      delay: notification.delay || 3000,
      notificationClass: notification.notificationClass || 'info'
    }
    this.notifications.push(newNotification);
    this.notificationAdded.emit(newNotification);
    //setting notification timer
    setTimeout(() => {
      this.removeAt(this.notifications.indexOf(newNotification));
    }, newNotification.delay)
  }

  removeAt(index: number) {
    this.notificationRemoved.emit(this.notifications.splice(index, 1)[0]);
  }

  //accessors
  public get notifications() {
    return this._notifications;
  }
}
