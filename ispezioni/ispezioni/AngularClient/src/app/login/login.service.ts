import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { UserService } from '../user/user.service';
import { AppService } from 'src/app/app.service';

declare let Swal: any;
//da spostare in un file separato
declare class GisaSpid {
  static spidUserData: any;
  static entraConSpid(
    event?: any,
    formId?: any,
    formParam?: any,
    functionName?: string,
    userField?: any,
    exceptionsJson?: any
  ): void;
  static logoutSpid(redirectTo: string): void;
}

@Injectable()
export class LoginService {
  loggingDevice?: string;
  
  constructor(private us: UserService, private router: Router, public app: AppService) {
    (window as any).getSpidUser = (spidUser: any) => {
      this.login(spidUser);
    };
  }

  login(user: any) {
    console.log('--- logging in ---');
    console.log(user);
    let params = {
      nome: user.firstName,
      cognome: user.lastName,
      cf: user.fiscalCode,
      insert: user.insert || 'false',
      device: this.loggingDevice,
    };
    this.us.findUser(params).subscribe(async (usr: any) => {
      console.log('--- user found ---');
      console.log(usr);
      let esito = JSON.parse(usr[0].id).esito;
      let ret = JSON.parse(usr[0].id).valore;
            //utente registrato
      if (esito) {
        if(usr.length == 1){
          localStorage.setItem('token', usr[0].token);
          this.app.nomeAndCognome = usr[0].nome + " " + usr[0].cognome;
          this.app.userRuolo = usr[0].ruoloUtente;
          this.app.userAmbito = usr[0].ambito;
          this.router.navigateByUrl('/dashboard?afterLogin=1');
          console.log(usr[0]);
        }else{
          let roleOptions: any = {};
          usr.forEach((u: any, i: number) => {
            roleOptions[i] = u.ruoloUtente + (u.ambito != '' ? (' - ' + u.ambito) : '')
          })
          Swal.fire({
            title: 'Hai più ruoli associati',
            input: 'select',
            inputOptions: roleOptions,
            inputPlaceholder: 'Seleziona ruolo...',
            showCancelButton: true,
            inputValidator: (value: any) => {
              if(!value)
                return;
              localStorage.setItem('token', usr[value].token);
              this.app.nomeAndCognome = usr[value].nome + " " + usr[value].cognome;
              this.app.userRuolo = usr[value].ruoloUtente;
              this.app.userAmbito = usr[value].ambito;
              this.router.navigateByUrl('/dashboard?afterLogin=1');
              console.log(usr[value]);
            }
          })
        }
      } else if (ret == -3) {
        Swal.fire({
          title: 'Registrazione',
          text: 'Registrarsi al sistema "G.I.S.A. - Sicurezza lavoro" come Profilo Notificatore?',
          icon: 'warning',
          showCancelButton: true,
          confirmButtonText: 'Ok, accetto',
          cancelButtonText: 'Non voglio registrarmi',
        }).then((result: any) => {
          //accetto di registrarmi
          if (result.value) {
            this.login({
              firstName: user.firstName,
              lastName: user.lastName,
              fiscalCode: user.fiscalCode,
              insert: 'true',
            });
          }
        });
      }
    });
  }

  loginSpid() {
    GisaSpid.entraConSpid(null, null, null, 'getSpidUser');
  }

  logout() {
    localStorage.removeItem('token');
    GisaSpid.logoutSpid('/');
  }
}
