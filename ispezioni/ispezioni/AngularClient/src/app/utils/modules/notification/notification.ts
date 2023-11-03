export interface Notification {
  content: string;
  delay: number; //TODO make it accept only non-negative integers
  notificationClass: 'info' | 'success' | 'error' | 'warning';
}

