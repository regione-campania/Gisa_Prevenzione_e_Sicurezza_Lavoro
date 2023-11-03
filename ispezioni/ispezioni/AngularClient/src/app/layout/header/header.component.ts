import { ɵWebAnimationsStyleNormalizer } from '@angular/animations/browser';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AppService } from 'src/app/app.service';
import { LoginService } from 'src/app/login/login.service';
import { UserService } from 'src/app/user/user.service';
import { environment } from 'src/environments/environment';
import Swal from 'sweetalert2';


@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss'],
})
export class HeaderComponent implements OnInit {
  isMenuCollapsed = true;

  randomParameterManuale = Math.floor(Math.random() * 1000);

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private ls: LoginService,
    public app: AppService,
    public us: UserService
  ) {}

  ngOnInit(): void {
    console.log("this.us.authToken:", this.us.authToken);
    if (this.us.authToken != '') {
      this.us.user.subscribe(res => {
        this.app.nomeAndCognome = res.cognome + " " + res.nome;
        this.app.userRuolo = res.ruoloUtente;
      });
    }
  }

  logout() {
    this.ls.logout();
  }

  collapse(){
    this.isMenuCollapsed = !this.isMenuCollapsed;
  }

  downloadManuale() {
    if (this.app.manualiArray.length > 1) {
      Swal.fire({
        title: 'Quale Manuale Scaricare?',
        showDenyButton: true,
        showCancelButton: false,
        confirmButtonText: 'Ispezioni e PagoPA',
        denyButtonText: 'Notifiche',
        denyButtonColor: '#0055af',
      }).then((result: any) => {
        if (result.isConfirmed) {
          window.open(environment.manualeIspezioni, '_blank');
        }
        else if (result.isDenied)
          window.open(environment.manualeNotifiche, '_blank');
      });
    }
    else {
      this.app.manualiArray.forEach(link => {
        console.log("link:", link);
        window.open(link, '_blank');
      })
    }
  }
}
