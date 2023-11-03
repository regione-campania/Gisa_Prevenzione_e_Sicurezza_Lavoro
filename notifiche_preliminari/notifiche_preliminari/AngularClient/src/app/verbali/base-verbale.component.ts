import { Component, OnInit } from '@angular/core';
import { VerbaliService } from './verbali.service';
import { FormArray, FormBuilder, FormGroup, FormControl } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';

@Component({
    selector: 'app-base-verbale',
    templateUrl: './base-verbale.component.html',
    styleUrls: ['./base-verbale.component.scss']
})

//componente di base per i verbali, tutti i verbali delle fasi ispezione devono estenderlo
export class BaseVerbaleComponent implements OnInit {

   verbale: any
   verbaleForm = this.fb.group({})
   ID_VERBALE: any
   ID_MODULO: any

  constructor(
    private vs: VerbaliService,
    private fb: FormBuilder,
    private route: ActivatedRoute
  ) { 
    this.route.queryParams.subscribe((params: any) => {
      this.ID_VERBALE = params.idVerbale;
      this.ID_MODULO = params.idModulo;
    })
  }

  ngOnInit(): void {
    this.vs.getJsonVerbale(this.ID_VERBALE).subscribe(json =>{
      this.verbale = JSON.parse(json.get_verbale_valori)
      console.log(this.verbale)
      this.verbaleForm = this.fb.group({
        verbale: this.fb.group(this.verbale)
      })
    })
  }

  onSubmit(): void {
    console.log(this.verbaleForm.value.verbale);
    const message = {idVerbale: this.ID_VERBALE, idModulo: this.ID_MODULO};
    this.vs.setJsonVerbale(this.verbaleForm.value.verbale).subscribe((res: any) => {
      console.log(res);
      if(!res.esito){
        alert("Errore in fase di salvataggio");
        return
      }
      window.opener.postMessage(JSON.stringify(message), '*')
    })
  }

  changeCheckBox(event: any){
    console.log(event);
    this.verbale[event.target.name] = event.target.checked;
    this.verbaleForm.value.verbale[event.target.name] = event.target.checked;
  }

}
