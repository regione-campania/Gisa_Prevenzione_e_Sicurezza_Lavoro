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

    const dynamicScripts = ['https://gel.gisacampania.it/js/GisaSpid.js', './../assets/js/FileSaver.js'];
    for (let i = 0; i < dynamicScripts.length; i++) {
      const node = document.createElement('script');
      node.src = dynamicScripts[i];
      node.type = 'text/javascript';
      node.async = false;
      node.charset = 'utf-8';
      document.getElementsByTagName('head')[0].appendChild(node);
    }
  }
}
