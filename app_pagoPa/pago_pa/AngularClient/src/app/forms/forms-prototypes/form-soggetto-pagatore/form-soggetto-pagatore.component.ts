import { Component, Input, OnInit } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { AbstractForm } from '../abstract-form';
import { AnagraficaService } from 'src/app/anagrafica/anagrafica.service';
import { AFormService } from '../../a-form-service';
import { TemplateService } from 'src/app/utils/services/template-service/template.service';
import { formatDate } from '@angular/common';
import { Utils } from '../../../utils/utils.class';

@Component({
  selector: 'form-soggetto-pagatore',
  templateUrl: './form-soggetto-pagatore.component.html',
  styleUrls: ['./form-soggetto-pagatore.component.scss'],
})
export class FormSoggettoPagatoreComponent
  extends AbstractForm
  implements OnInit {
  @Input() type: 'trasgressore' | 'obbligato_in_solido' = 'trasgressore';

  name = 'formSoggettoPagatore';
  anagrafica: any = {};
  giorni_scadenza = 30;
  avviso_scadenza = '';
  private _hideInputdata = false;
  dataNotifica = formatDate(new Date, 'YYYY-MM-dd', 'en-US');
  data_verbale = this.dataNotifica;
  dataNotificaString = formatDate(new Date, 'YYYY-MM-dd', 'en-US').replace(/-/g, "/");

  constructor(
    protected override fb: FormBuilder,
    public as: AnagraficaService,
    public fs: AFormService,
    public ts: TemplateService
  ) {
    super(fb);
  }

  ngOnInit(): void {
    //building form
    this.form = this._buildForm();
    //init anagrafica
    this.as.getImprese().subscribe((res) => (this.anagrafica.imprese = res));
    this.as.getComuni().subscribe((res) => (this.anagrafica.comuni = res));
    this.as.getSoggettiFisici().subscribe((res) => {
      this.anagrafica.soggettiFisici = res;
      this.anagrafica.soggettiFisici = this.anagrafica.soggettiFisici.map(
        (obj: any) => {
          obj.nominativo = `${obj.nome} ${obj.cognome}`;
          return obj;
        }
      );
    });

    /* this.updateValidators(); */
  }

  private _buildForm() {
    return this.fb.group(
      {
        tipo_pagatore: this.fb.control('F'),
        /* p_iva: this.fb.control('', Validators.pattern(/\w+/)),
        rag_sociale: this.fb.control(''), */
        cod_fiscale: this.fb.control('', [Validators.required, Validators.pattern(/\w+/)]),
        nominativo: this.fb.control('', Validators.required),
        cognome: this.fb.control('', Validators.required),
        indirizzo: this.fb.control('', Validators.required),
        civico: this.fb.control('', Validators.required),
        cap: this.fb.control('', [
          Validators.required,
          Validators.pattern(/\d+/),
        ]),
        comune: this.fb.control('', Validators.required),
        cod_provincia: this.fb.control('', Validators.required),
        nazione: this.fb.control('IT', Validators.required),
        email: this.fb.control('', [
          Validators.required, 
          Validators.pattern("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$")
        ]),
        telefono: this.fb.control('', [
          Validators.required,
          Validators.pattern(/\d+/),
        ]),
        mod_contestazione: this.fb.control('I', Validators.required),
        data_notifica: this.fb.control(formatDate(new Date, 'YYYY-MM-dd', 'en-US'), Validators.required)
      }, {validator: this.cognomeValidator}
    );
  }

  cognomeValidator(group: FormGroup) {
    if (group.controls['tipo_pagatore'].value === 'F'){
      return Validators.required(group.controls['cognome']);
    }
    return null;
  }

  patchImpresa(findBy: 'partita_iva' | 'ragione_sociale', value: any) {
    console.log('patch impresa');
    let impresa = this.anagrafica.imprese.find(
      (imp: any) => imp[findBy].trim() == value.trim()
    );
    if (impresa) {
      let patch = {
        cod_fiscale: impresa.partita_iva,
        nominativo: impresa.ragione_sociale,
      };
      this.form.patchValue(patch);
    }
  }

  patchComune(comune: any) {
    console.log(comune);
    let com = this.anagrafica.comuni.find((c: any) => c['comune'].toUpperCase() === comune.toUpperCase());
    if (com) {
      let patch = {
        comune: com.comune,
        cod_provincia: com.cod_provincia,
        nazione: 'IT',
      };
      this.form.patchValue(patch);
      this.fs.lockInput(document.querySelector("#provincia") as HTMLInputElement);
      this.fs.lockInput(document.querySelector("#nazione") as HTMLInputElement);
      return true;
    }
    return false;
  }

  patchComune2(comune: any) {
    this.patchComune(comune.target.value.toUpperCase())
  }

  patchPersona(findBy: 'nominativo' | 'codice_fiscale', value: any) {
    let persona = this.anagrafica.soggettiFisici.find(
      (p: any) => p[findBy] === value
    );
    if (persona) {
      let patch = {
        cod_fiscale: persona.codice_fiscale,
        nominativo: persona.nome,
        cognome: persona.cognome,
      };
      this.form.patchValue(patch);
    }
  }

  changeNotifica(evt: any) {
    // Caso Raccomandata A/R o Consegna a mano
    if (evt.target.value == 'R') {
      // this.form.controls['data_notifica']?.enable();
      this.giorni_scadenza = 30;
      this.avviso_scadenza = 'La data notifica dovrà essere obbligatoriamente aggiornata una volta ricevuta la cartolina di ritorno della raccomandata.'
      this._hideInputdata = true;
    }
    // Caso Contestazione Immediata o PEC
    else {
      // this.form.controls['data_notifica']?.disable();
      if (evt.target.value == 'I') {this.dataNotifica = this.data_verbale; this._hideInputdata = false; }
      if (evt.target.value == 'P') {this.dataNotifica = formatDate(new Date, 'YYYY-MM-dd', 'en-US'); this._hideInputdata = true; }
      // this.dataNotificaString = this.dataNotifica.replace(/-/g, "/");
      this.form.controls['data_notifica']?.setValue(this.dataNotifica);
      this.giorni_scadenza = 30;
      this.avviso_scadenza = '';
    }
  }

  updateValidators() {
    let tipoPag = this.form.get('tipo_pagatore')!;
    let pIva = this.form.get('p_iva')!;
    let ragSociale = this.form.get('rag_sociale')!;
    let codFiscale = this.form.get('cod_fiscale')!;
    let nominativo = this.form.get('nominativo')!;
    if (tipoPag.value === 'G') {
      this.fs.removeValidators(codFiscale, Validators.required);
      this.fs.removeValidators(nominativo, Validators.required);
      this.fs.addValidators(pIva, Validators.required);
      this.fs.addValidators(ragSociale, Validators.required);
    } else {
      this.fs.removeValidators(pIva, Validators.required);
      this.fs.removeValidators(ragSociale, Validators.required);
      this.fs.addValidators(codFiscale, Validators.required);
      this.fs.addValidators(nominativo, Validators.required);
    }
  }

  // Controlla se Soggetto Giuridico o Persona Fisica
  checkTipoPagatore() {
    if (this.form.get("tipo_pagatore")?.value == "G") return true;
    else return false;
  }

  // Pulisce i campi quando cambi tipo pagatore
  changeTipoPagatore(e: any) {
    this.form.patchValue({
      cod_fiscale: '',
      nominativo: '',
      cognome: ''
    });
  }

  parseData(data: string){
    return Utils.fromISODateToLocaleDate(data);
  }

  // Getter Methods
  public get hideInputdata() {
    return this._hideInputdata;
  }
}

