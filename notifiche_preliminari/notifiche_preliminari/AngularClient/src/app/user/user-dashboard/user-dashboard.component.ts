import { Component, OnInit } from '@angular/core';
import { UserService } from '../user.service';
import { Router } from '@angular/router';
import { AppService } from 'src/app/app.service';

@Component({
  selector: 'app-user-dashboard',
  templateUrl: './user-dashboard.component.html',
  styleUrls: ['./user-dashboard.component.scss']
})
export class UserDashboardComponent implements OnInit {

  constructor(
    private us: UserService,
    private router: Router,
    private app: AppService
    ) {
      this.app.pageName = 'Gestione Notifiche'
    }

  user?: any

  ngOnInit(): void {
    if(this.us.user == null || this.us.user.cf == null)
      this.router.navigate(['/'])
    else{

    }
      this.user = this.us.user
      console.log(this.us.user.id);
      this.user!.ruolo = JSON.parse(JSON.parse(this.us.user.id).info).ruolo //nel ritorno del servizio, in info ho il ruolo
      this.user!.id_asl = JSON.parse(JSON.parse(this.us.user.id).info).site_id //nel ritorno del servizio, in info ho il ruolo
  }

}
