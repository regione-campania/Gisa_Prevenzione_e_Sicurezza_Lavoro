import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AppService {
  pageName = '';
  nomeAndCognome = "";
  userRuolo = "";
  userAmbito = "";
  isMobileView;
  manualiArray:string[] = [];

  constructor() {
    this.isMobileView = this.checkIfMobileView();
    window.addEventListener('resize', () => this.isMobileView = this.checkIfMobileView())
  }

  checkIfMobileView() {
    return window.innerWidth <= 768;
  }

}
