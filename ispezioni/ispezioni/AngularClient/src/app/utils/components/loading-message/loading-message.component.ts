import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'loading-message',
  templateUrl: './loading-message.component.html',
  styleUrls: ['./loading-message.component.scss']
})
export class LoadingMessageComponent {
  @Input() message: string = 'Caricamento in corso...';

  constructor() { }

}
