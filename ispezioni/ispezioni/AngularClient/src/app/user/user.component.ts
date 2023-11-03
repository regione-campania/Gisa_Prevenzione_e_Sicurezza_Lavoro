import { Component, OnInit } from '@angular/core';

/** Permette di entrare nell'area riservata all'utente */
@Component({
  selector: 'app-user',
  templateUrl: './user.component.html',
  styleUrls: ['./user.component.scss']
})
export class UserComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
    console.log('--- UserComponent ---')
  }

}
