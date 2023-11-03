import { Location } from '@angular/common';
import {
  AfterViewInit,
  ChangeDetectorRef,
  Component,
  EventEmitter,
  Input,
  OnInit,
  Output,
  ViewChild,
} from '@angular/core';
import { FormArray, FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { NgbPopoverConfig } from '@ng-bootstrap/ng-bootstrap';
import { AnagraficaService } from 'src/app/anagrafica/anagrafica.service';
import { IspezioniService } from 'src/app/user/ispezioni/ispezioni.service';
import { AFormService } from 'src/app/forms/a-form-service';
import { AbstractForm } from 'src/app/forms/forms-prototypes/abstract-form';
import { FormSoggettoPagatoreComponent } from 'src/app/forms/forms-prototypes/form-soggetto-pagatore/form-soggetto-pagatore.component';
import { TemplateService } from 'src/app/utils/services/template-service/template.service';
import { isNumber, isPositiveNumber } from 'src/app/utils/validators';
import { SanzioniService } from '../sanzioni.service';
import { formatDate } from '@angular/common';

declare let Swal: any;

/** Form Sanzione */

@Component({
  selector: 'form-sanzione',
  templateUrl: './sanzione.component.html',
  styleUrls: ['./sanzione.component.scss'],
})
export class SanzioneComponent
  extends AbstractForm
  implements OnInit, AfterViewInit {
  @ViewChild('formTrasgressore')
  formTrasgressore?: FormSoggettoPagatoreComponent;
  @ViewChild('formObbligato') formObbligato?: FormSoggettoPagatoreComponent;
  isFromFase = false;
  anagrafica: any = {};
  moduliVerbale: any;
  private _dataNotifica = formatDate(new Date, 'YYYY-MM-dd', 'en-US');
  private _dataNotificaString = this._dataNotifica.replace(/-/g, "/");

  override form = this.fb.group({
    id_ispezione_fase: this.fb.control(''),
    info_pagamento: this.fb.control(0, [Validators.required, isPositiveNumber]),
    info_verbale: this.fb.group({
      proc_pen: this.fb.control(''),
      rgnr: this.fb.control(''),
      numero_protocollo: this.fb.control(''),
      tipo_verbale: this.fb.control('', [Validators.required]),
      data_verbale: this.fb.control('', [Validators.required]),
      violazioni: this.fb.array([]),
      cantiereOrImpresa: this.fb.control('', [Validators.required]),
      descrizione_libera: this.fb.control('', Validators.required),
    }),
    info_pagatore: this.fb.group({}),
  });

  constructor(
    protected override fb: FormBuilder,
    private anagraficaService: AnagraficaService,
    private sanzioniService: SanzioniService,
    private ispezioniService: IspezioniService,
    public fs: AFormService,
    public ts: TemplateService,
    private changeDetector: ChangeDetectorRef,
    private popoverConf: NgbPopoverConfig,
    private location: Location
  ) {
    super(fb);
    this.popoverConf.triggers = '';
    this.popoverConf.autoClose = false;
    this.popoverConf.popoverClass = 'error-popover';
  }

  ngOnInit(): void {
    console.log(this.data);
    //distinguo se la sto inserendo dalla fase o slegata
    if (this.data != null) this.isFromFase = true;
    //se vengo dalla fase inserisco l'id, altrimenti -1
    this.form
      .get('id_ispezione_fase')
      ?.setValue(!this.isFromFase ? -1 : this.data.fase.id_ispezione_fase);
    this.anagraficaService
      .getComuni()
      .subscribe((c) => (this.anagrafica.comuni = c));
    this.anagraficaService
      .getImprese()
      .subscribe((imp) => (this.anagrafica.imprese = imp));
    this.ispezioniService.getModuliVerbale().subscribe((res: any) => {
      console.log('--- moduli verbale ---');
      console.log(res);
      this.moduliVerbale = res.filter((mod: any) => { return mod.is_pagopa });
    })
    this.addViolazione();
  }

  override ngAfterViewInit(): void {
    super.ngAfterViewInit();
    if (this.formTrasgressore) {
      (this.form.get('info_pagatore') as FormGroup).setControl(
        'trasgressore',
        this.formTrasgressore?.form
      );
      this.form.updateValueAndValidity();
    }
    this.changeDetector.detectChanges();
  }



  override submit(): void {
    this.form.markAllAsTouched();
    if(!this.form.valid){
      let invalids = document.getElementsByClassName('ng-invalid');
      for (var i = 0; i < invalids.length; i++) {
        if(invalids[i].attributes.getNamedItem('errorName')){
          Swal.fire({ text: `Campo ${invalids[i].attributes.getNamedItem('errorName')?.value} vuoto o non valido`, icon: 'warning' });
          return;
        }
    }

      
    }
    console.log("this.form.value:", this.form.value);
    if (this.form.value['info_pagatore'].trasgressore.mod_contestazione == 'I')
      this.form.value.info_pagatore.trasgressore.data_notifica = this.form.value['info_verbale'].data_verbale;
    if (this.form.value['info_verbale'].data_verbale.trim() != new Date().toJSON().slice(0,10) && this.form.value['info_pagatore'].trasgressore.mod_contestazione == 'I') {
      Swal.fire({ text: `Attenzione! La data verbale non può essere diversa dalla data odierna per la modalità di Contestazione Immediata.`, icon: 'warning' });
      return;
    }
    if (this.form.value['info_verbale'].cantiereOrImpresa.trim() === "") {
      Swal.fire({ text: `Attenzione! Selezionare Cantiere o Impresa.`, icon: 'warning' });
      return;
    }
    if (this.form.value['info_pagatore'].trasgressore.tipo_pagatore.trim() === "G") {
      if(this.form.value['info_pagatore'].trasgressore.cod_fiscale.trim().startsWith(this.form.value['info_pagatore'].trasgressore.nazione.trim()))
        this.form.value['info_pagatore'].trasgressore.cod_fiscale = this.form.value['info_pagatore'].trasgressore.cod_fiscale.trim().replace(this.form.value['info_pagatore'].trasgressore.nazione.trim(), '');
      if(!/^\d/.test(this.form.value['info_pagatore'].trasgressore.cod_fiscale.trim())){
        Swal.fire({ text: `La partita IVA deve contenere solo numeri. Se è stato inserito il codice nazione, deve corrispondere con la nazione inserita.`, icon: 'warning' });
        return;
      }
    }
    if (this.form.value['info_pagatore'].trasgressore.email.trim() === "") {
      Swal.fire({ text: `Attenzione! Inserire il campo email.`, icon: 'warning' });
      return;
    } else if (this.validateEmail(this.form.value['info_pagatore'].trasgressore.email.trim()) == false) {
      Swal.fire({ text: `Attenzione! Inserire una email valida.`, icon: 'warning' });
      return;
    }
    if (this.form.value['info_pagatore'].trasgressore.data_notifica.trim() < new Date().toJSON().slice(0,10)) {
      Swal.fire({ text: `Attenzione! La data contestazione/notifica non può essere inferiore alla data odierna.`, icon: 'warning' });
      return;
    }
    for (let i = 0; i < this.violazioniAsFormArray.value.length; i++) {
      if (this.violazioniAsFormArray.value[i].norma === 'altro')
        this.violazioniAsFormArray.value[i].norma = this.violazioniAsFormArray.value[i].altra_norma_violata;
    }
    console.log('--- this FormGroup ---');
    console.log(this.form);
    console.log('--- this form value ---');
    console.log(this.form.value);
    this.sanzioniService
      .insertSanzione(this.form.value)
      .subscribe((res: any) => {
        console.log(res);
        if (!res.esito) Swal.fire({ text: res.msg.replace('paaSILImportaDovuto:', ''), icon: 'warning' });
        else {
          Swal.fire({
            // text: res.msg,
            icon: 'success',
            html: res.html,
          }).then(() => {
            this.submitEvent.emit();
            if (!this.isFromFase) this.location.back();
          });
        }
      });
  }

  checkAltroValue(articoloValue: any) {
    return true ? articoloValue == "altro" : false;
  }

  addViolazione() {
    if (this.pendingViolazione) {
      Swal.fire({
        text: 'Valorizzare violazione precedente prima di aggiungerne una nuova',
        icon: 'warning',
      })
      return;
    }
    this.violazioniAsFormArray.push(
      this.fb.group({
        punto_verbale_prescrizione: this.fb.control('', [Validators.required]),
        articolo_violato: this.fb.control('', [Validators.required]),
        norma: this.fb.control('D.Lgs. 81/08', [Validators.required]),
        altra_norma_violata: this.fb.control(''),
      }, { validator: this.altraNormaValidator })
    );
  }

  // Aggiungi il validator required solamente se visibile
  altraNormaValidator(group: FormGroup) {
    console.log(group);
    group.controls['altra_norma_violata'].clearValidators();
    if (group.controls['norma'].value === 'altro'){
      //return Validators.required(group.controls['altra_norma_violata']);
      group.controls['altra_norma_violata'].setValidators([Validators.required]);
    }
    return null;
  }

  // getter methods
  get violazioniAsFormArray() {
    return this.form.get('info_verbale.violazioni') as FormArray;
  }

  get violazioniAsArray() {
    return Array.from(this.violazioniAsFormArray.controls) as FormGroup[];
  }

  get pendingViolazione() {
    let last = this.violazioniAsFormArray.at(
      this.violazioniAsFormArray.length - 1
    ) as FormGroup;
    if (!last) return undefined;

    //controlla che l'ultimo elemento inserito abbia almeno un campo valorizzato
    //se ce l'ha allora NON c'è alcun elemento in stato 'pending'
    if (last.controls['norma'].value == 'altro' && !last.controls['altra_norma_violata'].value)
      return last;

    for (let c in last.controls)
      if (c != 'altra_norma_violata' && !last.controls[c].value)
        return last;

    //alla fine del ciclo, se tutti i campi dell'elemento sono 'falsy' l'elemento è ritornato
    return undefined;
  }

  // Controlla che l'email sia valida
  validateEmail = (email: any) => {
    const expression: RegExp = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/;
    const result: boolean = expression.test(email);
    console.log('e-mail is ' + (result ? 'correct' : 'incorrect'));
    return result;
  }

  // Cambia data Contestazione background
  changeData(evt: any) {
    const currentDataVerbale = this.form.value['info_verbale'].data_verbale;
    console.log('changeData', currentDataVerbale);
    if (this.formTrasgressore != undefined) {
      this.formTrasgressore.data_verbale = currentDataVerbale;
      if (this.form.value['info_pagatore'].trasgressore.mod_contestazione == 'I') {
        this.formTrasgressore.dataNotifica = currentDataVerbale;
        this.formTrasgressore.dataNotificaString = this.formTrasgressore.dataNotifica.replace(/-/g, "/");
        this.form.value.info_pagatore.trasgressore.data_notifica = currentDataVerbale;
      }
    }
  }

  public get dataNotificaString() {
    return this._dataNotificaString;
  }
}
