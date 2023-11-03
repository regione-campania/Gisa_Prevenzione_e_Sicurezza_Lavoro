import { Component, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NgbModal, NgbActiveModal } from '@ng-bootstrap/ng-bootstrap';
import { AnagraficaService } from 'src/app/anagrafica/anagrafica.service';
import { IspezioniService } from 'src/app/user/ispezioni/ispezioni.service';
import { AbstractForm } from '../abstract-form';
import { Utils } from '../../../utils/utils.class';
import { UserService } from 'src/app/user/user.service';

declare const Swal: any;

@Component({
  selector: 'form-cantiere',
  templateUrl: './form-cantiere.component.html',
  styleUrls: ['./form-cantiere.component.scss'],
})
export class FormCantiereComponent extends AbstractForm implements OnInit {
  name = 'formCantiere';
  anagrafica: any = {};
  datiCantiereModifica: any = null;

  override form = this.fb.group({
    via: this.fb.control('', Validators.required),
    civico: this.fb.control('', Validators.required),
    comune: this.fb.control('', Validators.required),
    id_comune: this.fb.control('', Validators.required),
    cod_provincia: this.fb.control('', Validators.required),
    cap: this.fb.control('', Validators.required),
    denominazione: this.fb.control('', Validators.required),
    id_natura_opera: this.fb.control('', Validators.required),
    altro: this.fb.control('', Validators.required),
    data_presunta: this.fb.control('', Validators.required),
    durata_presunta: this.fb.control('', Validators.required),
    numero_imprese: this.fb.control('', Validators.required),
    numero_lavoratori: this.fb.control('', Validators.required),
    ammontare: this.fb.control('', Validators.required),
    cantiere_imprese: this.fb.array([]),
    persona_ruoli: this.fb.array([]),
    id_access_ispettore: this.fb.control('', Validators.required)
  });

  constructor(
    protected override fb: FormBuilder,
    protected as: AnagraficaService,
    private is: IspezioniService,
    private us: UserService,
    private modalService: NgbModal
  ) {
    super(fb);
  }

  ngOnInit(): void {
    this.as.getImpreseSedi().subscribe((imp) => {
      this.anagrafica.imprese = imp;
    });
    this.as.getComuniCantiere().subscribe(com => {
      this.anagrafica.comuni = com;
      this.us.user.subscribe((u: any) => {
        this.form.patchValue({id_access_ispettore: parseInt(u.idUtente)});
        this.anagrafica.comuni = this.anagrafica.comuni.filter((c: any) => {return c.codiceistatasl == u.idAslUtente })
      })
    })
    this.as.getNatureOpera().subscribe(nat => {
      console.log(nat);
      this.anagrafica.natureOpera = nat;
    })
    this.as.getSoggettiFisici().subscribe(nat => {
      console.log(nat);
      this.anagrafica.persone = nat;
    })
    this.as.getRuoliNotifica().subscribe(nat => {
      console.log(nat);
      this.anagrafica.ruoli = nat;
    })
    this.as.getDominiPec().subscribe(nat => {
      console.log(nat);
      this.anagrafica.dominiPec = Object.values(nat).map((value: any) => { return value.dominio_pec });
    })
  }

  override ngAfterViewInit(): void {
    let data = JSON.parse(localStorage.getItem('cantiereModal')!);
    if(data){
      this.datiCantiereModifica = data;
      localStorage.removeItem('cantiereModal');
      data.data_presunta = data.data_presunta.split(' ')[0];
      console.log(data.data_presunta);
      this.form.patchValue(data);
      this.is.getCantiereImprese(data.id_cantiere).subscribe((res: any) => {
        console.log(res);
        res.forEach((imp: any, i: number) => {
          this.addImpresa();
          this.impreseAsArray.at(i)?.patchValue(imp);
        })
      })
      this.is.getPersoneIspezione(data.id_cantiere).subscribe((res: any) => {
        console.log(res);
        res.forEach((pers: any, i: number) => {
          this.addPersona();
          pers.pec = pers.ruolo_pec;
          this.personeAsFormArray.at(i)?.patchValue(pers);
        })
      })
    }
  }

  addImpresa() {
    if (this.pendingImpresa){
      Swal.fire({ text: `Valorizzare impresa precedente`, icon: 'warning' });
      return;
    }
    this.impreseAsFormArray.push(
      this.fb.group({
        id: '',
        id_impresa: '',
        id_gisa: null,
        partita_iva: '',
        nome_azienda: this.fb.control('', Validators.required),
        codice_fiscale: '',
      })
    );
  }

  addPersona() {
    if (this.pendingPersona){
      Swal.fire({ text: `Valorizzare persona precedente`, icon: 'warning' });
      return;
    }
    this.personeAsFormArray.push(
      this.fb.group({
        id_ruolo: this.fb.control('', Validators.required),
        codice_fiscale: this.fb.control('', Validators.required),
        nome: this.fb.control('', Validators.required),
        cognome: this.fb.control('', Validators.required),
        pec: ''
      })
    );
  }

  // Capitalize first char key
  private capitalizeWords(string2Edit: string): string {
    string2Edit = string2Edit.replace(/_/g, " ");
    string2Edit = string2Edit.replace("id", " ");
    string2Edit = string2Edit.replace("cod", "codice");
    string2Edit = string2Edit.replace("via", "indirizzo");
    string2Edit = string2Edit.trim();
    var arrayString2Edit = string2Edit.split(" ");
    arrayString2Edit = arrayString2Edit.map(element => {
      return element.charAt(0).toUpperCase() + element.slice(1).toLocaleLowerCase();
    })
    string2Edit = arrayString2Edit.join(' ');
    if (string2Edit == 'Cap') string2Edit = string2Edit.toUpperCase();
    return string2Edit;
  }

  override submit(): void {
    this.form.markAllAsTouched();
    console.log("this.form.value:", this.form.value);

    // Check Comune se inserito manualmente e non tramite tendina
    let c = this.anagrafica.comuni.find((c: any) => c['comune'].toUpperCase().trim() === this.form.value.comune.toUpperCase().trim());
    console.log("c:", c);
    if (c) {
      if (this.form.value.comune && (this.form.value.id_comune != c.id || this.form.value.cod_provincia != c.cod_provincia)) {
        console.log("NO CONGRUENZA!");
        this.form.patchValue({ comune: this.form.value.comune.toUpperCase().trim(), cod_provincia: c.cod_provincia, id_comune: c.id })
      }
    }else{
      Swal.fire({ text: `Selezionare comune da lista`, icon: 'warning' });
      return;
    }

    // Controlla tutti i campi
    for (const key in this.form.value) {
      if (!this.form.value[key] && key != 'altro') {
        if (key == "durata_presunta" || key == "ammontare" || key == "numero_lavoratori" || key == "numero_imprese") {
          if (this.form.value[key] == 0) {
            Swal.fire({ text: `Attenzione! Il valore ${this.capitalizeWords(key)} deve essere maggiore di 0.`, icon: 'warning' });
            return;
          } else if (this.form.value[key] == null) {
            Swal.fire({ text: `Attenzione! Il valore ${this.capitalizeWords(key)} deve essere numerico e senza spazi`, icon: 'warning' });
            return;
          }
        }
        else {
          Swal.fire({ text: `Attenzione! Valorizzare ${this.capitalizeWords(key)}.`, icon: 'warning' });
          return;
        }
      }

      else if (this.form.value[key] && typeof this.form.value[key] === 'string') {
        if (this.form.value[key].trim().length === 0) {
          Swal.fire({ text: `Attenzione! Valorizzare ${this.capitalizeWords(key)}.`, icon: 'warning' });
          return;
        }
        else if ((key == 'cap') && isNaN(parseInt(this.form.value[key].trim()))) {
          Swal.fire({ text: `Attenzione! Il campo ${this.capitalizeWords(key)} deve essere un valore numerico.`, icon: 'warning' });
          return;
        }
      }
    }

    // Controlli specifici
    if (this.form.value.id_natura_opera == 0 && !this.form.value.altro) {
      Swal.fire({ text: `Attenzione! Specificare Natura Opera.`, icon: 'warning' });
      return;
    }

    if (this.form.value.cap == '80100') {
      Swal.fire({ text: `Attenzione! CAP 80100 per cantiere non consentito.`, icon: 'warning' });
      return;
    }

    if (this.form.value.cap.length != 5) {
      Swal.fire({ text: `Attenzione! Formato CAP cantiere non valido.`, icon: 'warning' });
      return;
    }

    if (this.form.value.numero_lavoratori < 3) {
      Swal.fire({ text: `Attenzione! Il valore numero presunto dei lavoratori in cantiere deve essere almeno 3.`, icon: 'warning' });
      return;
    }

    if (this.form.value.cantiere_imprese.length > this.form.value.numero_imprese) {
      Swal.fire({ text: `Il numero di imprese valorizzate non può essere maggiore del numero previsto di imprese e di lavoratori autonomi sul cantiere.`, icon: 'warning' });
      return;
    }

    // Controlli specifici Imprese
    var arrayPIVA = [];
    var arrayCF = [];

    // Modo per trovare i duplicati in un array
    let findDuplicates = (arr: any[]) => arr.filter((item, index) => arr.indexOf(item) != index);

    if(this.form.value.cantiere_imprese.length == 0){
      Swal.fire({ text: `Attenzione! Inserire almeno un'impresa.`, icon: 'warning' })
      return;
    }

    for (const keyImpresa in this.form.value.cantiere_imprese) {
      if (!this.form.value.cantiere_imprese[keyImpresa].nome_azienda || this.form.value.cantiere_imprese[keyImpresa].nome_azienda.trim() == '') {
        Swal.fire({ text: `Attenzione! Inserita impresa senza Ragione Sociale.`, icon: 'warning' })
        return;
      }

      if (
        (!this.form.value.cantiere_imprese[keyImpresa].partita_iva || this.form.value.cantiere_imprese[keyImpresa].partita_iva.trim() == '') 
        &&
        (!this.form.value.cantiere_imprese[keyImpresa].codice_fiscale || this.form.value.cantiere_imprese[keyImpresa].codice_fiscale.trim() == '')
        ) {
        Swal.fire({ text: `Attenzione! Inserita impresa senza partita IVA e codice fiscale. Valorizzare almeno uno dei due.`, icon: 'warning' })
        return;
      }

      //arrayPIVA.push(this.form.value.cantiere_imprese[keyImpresa].partita_iva);

      //controllo i cf solo se valorizzati non essendo obbligatori
      if(this.form.value.cantiere_imprese[keyImpresa].codice_fiscale && this.form.value.cantiere_imprese[keyImpresa].codice_fiscale.trim().length)
        arrayCF.push(this.form.value.cantiere_imprese[keyImpresa].codice_fiscale);
      if(this.form.value.cantiere_imprese[keyImpresa].partita_iva && this.form.value.cantiere_imprese[keyImpresa].partita_iva.trim().length)
        arrayPIVA.push(this.form.value.cantiere_imprese[keyImpresa].partita_iva);

      // console.log("[...new Set(findDuplicates(arrayPIVA))]:", [...new Set(findDuplicates(arrayPIVA))]);
      // console.log("[...new Set(findDuplicates(arrayCF))]:", [...new Set(findDuplicates(arrayCF))]);

      if ([...new Set(findDuplicates(arrayPIVA))].length > 0) {
        Swal.fire({ text: `Attenzione! Due o più imprese con lo stessa Partita IVA.`, icon: 'warning' })
        return;
      }

      if ([...new Set(findDuplicates(arrayCF))].length > 0) {
        Swal.fire({ text: `Attenzione! Due o più imprese con lo stesso Codice Fiscale.`, icon: 'warning' })
        return;
      }
    }

    if (this.pendingImpresa)
      this.impreseAsFormArray.removeAt(this.impreseAsFormArray.length - 1);
    console.log(this.form.value);

    this.form.value.id_natura_opera = parseInt(this.form.value.id_natura_opera);

    // Controlli persone
    if (this.form.value.persona_ruoli.length > 0) {

      // Trova le persone che hanno ruolo 'committente' e ritorna un array di soli id_ruoli
      let ruoli: number[] = this.form.value.persona_ruoli.map((value: any) => { return parseInt(value.id_ruolo) })
      console.log("ruoli:", ruoli);

      let duplicates = false;
      for (let i = 2; i < 5; i++) {
        if (ruoli.filter((x: any) => x == i).length > 1) duplicates = true;
      }
      if (duplicates) {
        Swal.fire({
          title: 'Attenzione',
          text: `Attenzione! È possibile avere solo più committenti.`,
          icon: 'warning'
        });
        return;
      }

      let error = false;
      this.form.value.persona_ruoli.forEach((persona: any) => {

        // Check che venga inserita la PEC quando per il ruolo questa è obbligatoria
        let ruoloPersona = this.anagrafica.ruoli.filter((r: any) => {return r.id == persona.id_ruolo})[0];

        if(!persona.codice_fiscale || persona.codice_fiscale.trim() == ''){
          Swal.fire({
            title: 'Attenzione',
            text: `Indicare il codice fiscale per il ${ruoloPersona.descr}.`,
            icon: 'warning'
          });
          error = true;
          return;
        }

        if(!persona.nome || persona.nome.trim() == ''){
          Swal.fire({
            title: 'Attenzione',
            text: `Indicare il nome per il ${ruoloPersona.descr}.`,
            icon: 'warning'
          });
          error = true;
          return;
        }

        if(!persona.cognome || persona.cognome.trim() == ''){
          Swal.fire({
            title: 'Attenzione',
            text: `Indicare il cognome per il ${ruoloPersona.descr}.`,
            icon: 'warning'
          });
          error = true;
          return;
        }

        // Check che venga selezionato il ruolo
        if (persona.id_ruolo && persona.id_ruolo.trim() == '') {
          Swal.fire({
            title: 'Attenzione',
            text: `Selezionare il ruolo per ${persona.nome} ${persona.cognome}.`,
            icon: 'warning'
          });
          error = true;
          return;
        }

        if (ruoloPersona.richiesta_pec && (persona.pec == null || persona.pec?.trim() == '')) {
          Swal.fire({
            title: 'Attenzione',
            text: `La PEC per il ruolo ${ruoloPersona.descr} di ${persona.nome} ${persona.cognome} è obbligatoria.`,
            icon: 'warning'
          });
          error = true;
          return;
        }

        // Check dominio PEC valido
        if (persona.pec && persona.pec != "" && !this.anagrafica.dominiPec.some((v: string) => persona.pec?.toUpperCase().includes(v.toUpperCase()))) {
          Swal.fire({
            title: 'Attenzione',
            text: `Il dominio della PEC per ${persona.nome} ${persona.cognome} non è valido.`,
            icon: 'warning'
          });
          error = true;
          return;
        }
      });

      if(error) 
        return;
    }

    if(this.datiCantiereModifica){
      this.form.value.id_cantiere = parseInt(this.datiCantiereModifica.id_cantiere);
      this.form.value.persona_ruoli.forEach((pr: any) => {
        pr.id_cantiere = parseInt(this.datiCantiereModifica.id_cantiere);
      })
      this.form.value.cantiere_imprese.forEach((ci: any) => {
        ci.id_cantiere = parseInt(this.datiCantiereModifica.id_cantiere);
        ci.ragione_sociale = ci.nome_azienda;
      })
      this.is.updateCantiere(this.form.value).subscribe((res: any) => {
        console.log(res);
        if (!res.esito) {
          Swal.fire({ text: res.msg.split(' [')[0], icon: 'warning' });
          return;
        } else {
          Swal.fire({
            text: 'Cantiere modificato correttamente!',
            icon: 'success',
          })
          this.submitEvent.emit(this.form.value)
          this.modalService.dismissAll();
        }
      })
    }else{
      this.is.insertCantiere(this.form.value).subscribe((res: any) => {
        console.log(res);
        if (!res.esito) {
          Swal.fire({ text: res.msg.split(' [')[0], icon: 'warning' });
          return;
        } else {
          Swal.fire({
            text: 'Cantiere inserito correttamente!',
            icon: 'success',
          })
          this.submitEvent.emit(this.form.value)
          this.modalService.dismissAll();
        }
      })
    }
  }

  setComuneCantiere(controlPath: any, value: any) {

    console.log("event:", value);

    let c = this.anagrafica.comuni.find((c: any) => c['comune'] === value);
    let com = {
      id_comune: c.id,
      comune: value,
      cod_provincia: c.cod_provincia,
    };
    this.patchValue(controlPath, com);
  }

  //accessors
  get impreseAsArray() {
    return Array.from(this.impreseAsFormArray.controls) as FormGroup[];
  }

  get impreseAsFormArray() {
    return this.form.get('cantiere_imprese') as FormArray;
  }

  get pendingImpresa() {
    let last = this.impreseAsFormArray.at(
      this.impreseAsFormArray.length - 1
    ) as FormGroup;
    if (!last) return undefined;
    //controlla che l'ultimo elemento inserito abbia almeno un campo valorizzato
    //se ce l'ha allora NON c'è alcun elemento in stato 'pending'
    for (let c in last.controls)
      if (last.controls[c].value)
        return undefined;
    //alla fine del ciclo, se tutti i campi dell'elemento sono 'falsy' l'elemento è ritornato
    return last;
  }

  get personeAsArray() {
    return Array.from(this.personeAsFormArray.controls) as FormGroup[];
  }

  get personeAsFormArray() {
    return this.form.get('persona_ruoli') as FormArray;
  }

  get pendingPersona() {
    let last = this.personeAsFormArray.at(
      this.personeAsFormArray.length - 1
    ) as FormGroup;
    if (!last) return undefined;
    //controlla che l'ultimo elemento inserito abbia almeno un campo valorizzato
    //se ce l'ha allora NON c'è alcun elemento in stato 'pending'
    for (let c in last.controls)
      if (last.controls[c].value)
        return undefined;
    //alla fine del ciclo, se tutti i campi dell'elemento sono 'falsy' l'elemento è ritornato
    return last;
  }

}
