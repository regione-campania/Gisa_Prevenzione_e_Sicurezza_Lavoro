import { Component, OnChanges, SimpleChanges } from '@angular/core';
import { environment } from './../environments/environment';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent {
  title = 'Gesdasic';
  ambiente = '';

  constructor() {
    this.ambiente = environment.ambiente;

    //loading GisaSpid.js
    const script = document.createElement('script');
    script.src = environment.gisaSpid;
    script.async = false;
    document.head.appendChild(script);
  }
}
