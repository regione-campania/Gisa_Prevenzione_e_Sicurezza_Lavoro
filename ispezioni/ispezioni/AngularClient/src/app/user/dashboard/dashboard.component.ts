import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AppService } from '../../app.service';
import { User } from '../user.interface';
import { SanzioniService } from '../sanzioni/sanzioni.service';
import Swal from 'sweetalert2';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss'],
})
export class DashboardComponent implements OnInit {
  user!: User; //provided by UserResolverService

  constructor(
    public appService: AppService,
    private route: ActivatedRoute,
    private router: Router,
    private ss: SanzioniService
  ) {
    this.appService.pageName = 'Dashboard';
  }

  ngOnInit(): void {
    this.route.data.subscribe((data) => {
      this.user = data['user'];
      if (this.user.endpoint.length === 1)
        this.router.navigateByUrl(this.user.endpoint[0].toLowerCase());
    });


    this.route.queryParams.subscribe((param: any) => {
      console.log(param);
      if(param.afterLogin){
        this.ss.getSanzioniDaAllegare().subscribe((sanzioni: any) => {
          console.log(sanzioni);
          if(sanzioni.length > 0){
            Swal.fire('Ci sono una o più ammende generate da associare', '', 'warning');
          }
        })
      }
    });
   

    this.appService.manualiArray = [];
    if (this.canAccess('ispezioni') || this.canAccess('sanzioni')) this.appService.manualiArray.push(environment.manualeIspezioni);
    if (this.canAccess('notifiche')) this.appService.manualiArray.push(environment.manualeNotifiche);
  }

  canAccess(endpoint: 'ispezioni' | 'notifiche' | 'sanzioni') {
    return this.user.endpoint.includes(endpoint.toUpperCase());
  }

}
