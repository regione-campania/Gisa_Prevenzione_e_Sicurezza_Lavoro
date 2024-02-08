import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { LoginService } from './login.service';
import { UserService } from '../user/user.service';
import { AppService } from '../app.service';
import { environment } from './../../environments/environment';

declare let Swal: any;

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent implements OnInit {
  _device: string = '';
  endpointRegistrazione = '';

  constructor(
    private route: ActivatedRoute,
    private ls: LoginService,
    private us: UserService,
    private app: AppService
  ) {
    this.app.pageName = 'Login';
    this._device = 'desktop';
    if (window.innerWidth < 992) this._device = 'mobile';
    if (window.matchMedia('(display-mode: standalone)').matches)
      this._device += '(pwa)';
    this.ls.loggingDevice = this._device;
  }

  ngOnInit(): void {
    this.app.manualiArray.push(environment.manualeNotifiche);
    this.endpointRegistrazione = environment.endpointRegistrazione;
    this.route.queryParams.subscribe((params) => {
      if (params['test'] === 'true') {
        let testUser = {
          firstName: 'test',
          lastName: 'test',
          fiscalCode: params['cf'],
        };
        this.ls.login(testUser);
      }
    });
    if (this.us.cookieAccepted == 'false') {
      Swal.fire({
        position: 'bottom-end',
        html: `
        <div style="font-size: 14px">
        Il portale "G.I.S.A. - Sicurezza e prevenzione sui luoghi di lavoro" utilizza i cookie. <br>
        Continuando a navigare sul sito accetterai automaticamente i cookie necessari e l'informativa alla privacy.
        </div>
        `,
        footer: `<a style="margin: 10px" href="/#/informativa">Link all'informativa sui cookie</a>
                <br>
                <a style="margin: 10px" href="./assets/informativaPrivacy.pdf">Link all'informativa alla privacy</a>`,
        showConfirmButton: true,
        confirmButtonText: 'Ok, accetto',
        backdrop: true,
      }).then(() => {
        this.us.cookieAccepted = 'true';
      });
    }
  }

  loginSpid() {
    this.ls.loginSpid();
  }
}
