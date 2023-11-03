import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AppService } from 'src/app/app.service';
import { UserService } from '../../user/user.service';

declare let GisaSpid: any;

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss'],
})
export class HeaderComponent implements OnInit {
  isMenuCollapsed = true;
  isNotificatore = true;

  pageName = 'Da Definire';

  randomParameterManuale = Math.floor(Math.random() * 1000);

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private us: UserService,
    public app: AppService
  ) {}

  ngOnInit(): void {
    this.isMenuCollapsed = true;
    console.log(this.us.userRole);
    this.isNotificatore = this.us.userRole == 'Profilo Notificatore';
    /*document.querySelectorAll('.nav-link').forEach((link) => {
      link.addEventListener('click', () => {
        this.isMenuCollapsed = true;
      });
    });*/
  }

  logoutSpid(url: string) {
    GisaSpid.logoutSpid(url);
  }

  goToDashboard() {
    this.router.navigate(['user', 'dashboard']);
  }

  goToIspezioni() {
    this.router.navigate(['ispezioni']);
  }

  collapse(){
    if(this.isMenuCollapsed == true)
      this.isMenuCollapsed = false;
    else
      this.isMenuCollapsed = true;
  }
}
