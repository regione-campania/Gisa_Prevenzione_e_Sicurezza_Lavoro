import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { IspezioniService } from 'src/app/user/ispezioni/ispezioni.service';
import { AbstractForm } from '../abstract-form';
import { ListaIspezioniComponent } from 'src/app/user/ispezioni/lista-ispezioni/lista-ispezioni.component';
import { formatDate } from '@angular/common';


declare let Swal: any;

@Component({
  selector: 'form-fase-ispezione',
  templateUrl: './form-fase-ispezione.component.html',
  styleUrls: ['./form-fase-ispezione.component.scss'],
})
export class FormFaseIspezioneComponent extends AbstractForm implements OnInit {

  name = 'formFaseIspezione';
  fase: any;
  impreseSelezionabili: any;
  currEsito: any;
  esitiFase?: any;
  moduli: any;
  currModulo: any;
  idFase: any;
  verbaleWindow: any;
  dataIspezione?: any;
  isCantiere: boolean = false;

  constructor(protected override fb: FormBuilder, private ispService: IspezioniService) {
    super(fb);
  }

  ngOnInit() {
    if(this.data.ispezione.id_cantiere)
      this.isCantiere = true;

    console.log("this.data.ispezione:", this.data.ispezione);
    this.dataIspezione = formatDate(this.data.ispezione.data_ispezione, 'YYYY-MM-dd', 'en-US');
    console.log("this.dataIspezione:", this.dataIspezione);

    this.ispService
      .getNuovaFase(this.data.ispezione.id_ispezione)
      .subscribe((nf: any) => {
        if (!nf.esito) {
          Swal.fire({ text: nf.msg, icon: 'error' });
          return;
        }
        this.idFase = nf.valore;
        this.ispService.getFaseInfo(this.idFase).subscribe((res: any) => {
          this.impreseSelezionabili = res.imprese_selezionabili;
          this.fase = res.fase;
          if(this.isCantiere)
            this.fase.id_impresa_sede = 'null';
          this.form = this.fb.group({
            fase: this.fb.group(res.fase),
            persone_sanzionate: this.fb.array(res.persone_sanzionate),
            verbali: this.fb.array(res.verbali),
          });
          /*this.form = this.fb.group({
            fase: this.fb.group({
              id_impresa_sede: this.fb.control(null, Validators.required),
              id_fase_esito: this.fb.control(null, Validators.required),
              data_fase: this.fb.control(null, Validators.required),
              note: this.fb.control(null),
            })
          });*/
          Object.keys((this.form.controls['fase']! as FormGroup).controls).forEach(key => {
            console.log(key);
            if(['note'].indexOf(key) < 0){
              (this.form.controls['fase']! as FormGroup).controls[key].setValidators(Validators.required)
              console.log((this.form.controls['fase']! as FormGroup).controls[key])
            }
          });
      });
    })
    this.ispService
      .getEsitiFase(this.data.ispezione.id_ispezione)
      .subscribe((res) => {
        this.esitiFase = res;
        console.log(this.esitiFase);
      });
    this.ispService.getModuliVerbale().subscribe((res) => {
      this.moduli = res;
    });
  }
}
