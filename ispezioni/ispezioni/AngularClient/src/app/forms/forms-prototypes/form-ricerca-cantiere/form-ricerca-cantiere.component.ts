import { animate, style, transition, trigger } from '@angular/animations';
import { Component, ElementRef, EventEmitter, OnInit, Output, TemplateRef, ViewChild, ViewContainerRef } from '@angular/core';
import { FormArray, FormBuilder, FormGroup } from '@angular/forms';
import { IspezioniService } from 'src/app/user/ispezioni/ispezioni.service';
import { NotificheService } from 'src/app/user/notifiche/notifiche.service';
import { UserService } from 'src/app/user/user.service';
import { AbstractForm } from '../abstract-form';

declare let Swal: any;

@Component({
  selector: 'form-ricerca-cantiere',
  templateUrl: './form-ricerca-cantiere.component.html',
  styleUrls: ['./form-ricerca-cantiere.component.scss'],
  animations: [
    trigger('collapse', [
      transition(':enter', [
        style({ opacity: 0, height: 0, overflow: 'hidden' }),
        animate('500ms', style({ opacity: 1, height: 'auto' })),
      ]),
      transition(':leave', [
        style({ opacity: '*', height: '*', overflow: 'hidden' }),
        animate('500ms', style({ opacity: 0, height: 0 })),
      ]),
    ]),
  ],
})
export class FormRicercaCantiereComponent
  extends AbstractForm
  implements OnInit
{
  @ViewChild('ricercaImpresa') formRicercaImpresa: any;
  @Output('openFormCantiere') openFormCantiere: EventEmitter<any> = new EventEmitter();
  name = 'formRicercaCantiere';

  cantieriAttivi: any;
  cantiereSelezionato: any;
  impreseCantiereSelezionato: any;
  private _personeCantiere?: any;

  constructor(
    protected override fb: FormBuilder,
    private ispezioni: IspezioniService,
    private ns: NotificheService,
    private is: IspezioniService,
    private us: UserService
  ) {
    super(fb);
  }

  ngOnInit(): void {
    this.loadCantieri();
  }

  loadCantieri(): void {
    console.log("----- Check Data Form Cantiere -----");
    console.log("this.data?.cantiere:", this.data?.cantiere);
    console.log("this.data:", this.data);
    // Imprese già presenti per il cantiere se sono in modalità modifica
    if (this.data?.imprese[0].id != null) {
      this.selezionaCantiere(this.data.cantiere, '#elemToScroll', null);
    }
    else {
      //this.reset();
      this.us.user.subscribe(user => {
        this.ispezioni.getCantieriAttivi().subscribe((res: any) => {
          this.cantieriAttivi = [];
          res.forEach((cantiere: any) => {
            if(cantiere.modificabile && cantiere.id_access_ispettore != user.idUtente){
              cantiere.modificabile = false;
            }
            if(cantiere.codiceistatasl == user.idAslUtente)
              this.cantieriAttivi.push(cantiere);
          });
          console.log("typeof cantieriAttivi:", typeof this.cantieriAttivi);
          console.log("cantieriAttivi:", this.cantieriAttivi);
          if(this.cantiereSelezionato)
            this.selezionaCantiere(this.cantiereSelezionato, this.lastElem, this.lastEvt, true)
        });
      })
      
    }
  }

  reloadCantieri() {
    /*this.ispezioni.getCantieriAttivi().subscribe((res) => {
      this.cantieriAttivi = res;
    });*/
    this.loadCantieri();
  }

  

  reset() {
    this.cantiereSelezionato = this.impreseCantiereSelezionato = null;
    this.form = this.fb.group({
      cantiere: this.fb.group({ cun: '', cuc: '', denominazione: '' }),
      imprese: [],
    });
  }

  private lastEvtTarget: any;
  private lastElem: any;
  private lastEvt: any

  selezionaCantiere(cantiere: any, elem: string, evt: any, afterUpdate?: boolean) {
    
    // console.log("this.impreseCantiereSelezionato prima di elaborare:", this.impreseCantiereSelezionato);

    if(afterUpdate){
      console.log(this.lastEvtTarget.closest(".clickable"))
      this.lastEvtTarget.closest(".clickable").style.backgroundColor = '#00D1FF';
      this.lastEvtTarget.closest(".clickable").style.color = 'white';
    }
    else if (evt != null) {
      // Change selected row color
      evt.target.parentNode.style.backgroundColor = '#00D1FF';
      evt.target.parentNode.style.color = 'white';
      if (this.lastEvtTarget && this.lastEvtTarget != evt.target) {
        this.lastEvtTarget.parentNode.style.backgroundColor = '';
        this.lastEvtTarget.parentNode.style.color = '';
      }
      
      
      this.lastEvtTarget = evt.target;
    }
    
    // Imprese del Cantieref
    console.log("cantiere:", cantiere);
    this.cantiereSelezionato = cantiere;
    this.lastElem = elem;
    this.lastEvt = evt;
    this.form = this.fb.group({});
    this.form.addControl('cantiere', this.fb.group(this.cantiereSelezionato));

    if (this.cantiereSelezionato.cun != null) {
      this.ns.getNotificaInfo(cantiere.id_notifica).subscribe((res) => {
        console.log('res.cantiere_imprese:', res.cantiere_imprese);
        this.impreseCantiereSelezionato = res.cantiere_imprese;
        if (this.impreseCantiereSelezionato != null) {
          console.log('this.impreseCantiereSelezionato:', this.impreseCantiereSelezionato);
          this.form.addControl('imprese', this.fb.array(this.impreseCantiereSelezionato));
        } else {
          console.log(`Cantiere: ${this.cantiereSelezionato.id} non ha imprese!`);
        }

        // Prende solamente le persone provviste di codice fiscale
        this._personeCantiere = res.persona_ruoli.filter((persona: any) => {if (persona.codice_fiscale) return persona});
        console.log("this._personeCantiere:", this._personeCantiere);
      });
    } else {
      if(this.data?.ispezione.descr_stato_ispezione == 'INIZIALE'){
        let idCantiere;
        if (this.data?.ispezione.descr_stato_ispezione != 'INIZIALE') idCantiere = this.data?.cantiere.id_cantiere; else idCantiere = cantiere.id;
        this.is.getCantiereImprese(idCantiere).subscribe((res) => {
            
          this.impreseCantiereSelezionato = res;
          
          if (this.impreseCantiereSelezionato != null) {
            console.log('this.impreseCantiereSelezionato:', this.impreseCantiereSelezionato);
            this.form.addControl('imprese', this.fb.array(this.impreseCantiereSelezionato));
          } else {
            console.log(`Cantiere: ${this.cantiereSelezionato.id} non ha imprese!`);
          }
        });
        // Recupera le persone legate al cantiere
        this.is.getPersoneIspezione(idCantiere).subscribe((res: any) => {
          this._personeCantiere = res.filter((persona: any) => {if (persona.codice_fiscale) return persona});
          console.log("this._personeCantiere:", this._personeCantiere);
        })
      }else{ //se è un cantiere già selezionato nell ispezione, prendo le imprese aggiunte nell'ispezione e non quelle presenti nel cantiere
        this.impreseCantiereSelezionato = this.data?.imprese;
      }
    }

    document.querySelector(elem)?.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'start' });
  }

  addingImpresa = false;

  //warning!: la struttura delle imprese di un cantiere è diversa da quelle presenti in formRicercaImpresa
  aggiungiImpresa(): void {
    let isFound = false;

    console.log("this.formRicercaImpresa.form.value:", this.formRicercaImpresa.form.value);
    console.log("this.formRicercaImpresa.impresaSelezionata:", this.formRicercaImpresa.impresaSelezionata);

    // Ritorna se il campo della partita IVA è vuoto
    if (this.formRicercaImpresa.form.value.partita_iva.trim().length == 0) {
      console.log("P.IVA vuota!");
      Swal.fire({
        text: `Attenzione non hai inserito alcuna Partita IVA`,
        icon: 'warning'
      });
      return;
    }

    // In entrambi i casi controlla che non venga inserita un'impresa già inserita
    if (this.formRicercaImpresa.impresaSelezionata != null) {
      console.log("Esiste impresa selezionata!");
      isFound = this.impreseCantiereSelezionato.some((el: { partita_iva: any; }) => {
        if (el.partita_iva == this.formRicercaImpresa.impresaSelezionata.partita_iva) {
          Swal.fire({
            text: `Attenzione hai inserito un'impresa già esistente!`,
            icon: 'warning'
          });
          return true;
        } else return false;
      });

      if (isFound) return;

      (this.form.get('imprese') as FormArray).push(
        this.fb.control(this.formRicercaImpresa.impresaSelezionata)
      );
      this.impreseCantiereSelezionato.push(
        this.formRicercaImpresa.impresaSelezionata
      );
    } else {
      console.log("Non esiste impresa selezionata!");

      isFound = this.impreseCantiereSelezionato.some((el: { partita_iva: any; }) => {
        if (el.partita_iva == this.formRicercaImpresa.form.value.partita_iva) {
          Swal.fire({
            text: `Attenzione hai inserito un'impresa già esistente!`,
            icon: 'warning'
          })
          return true;
        } else return false;
      });

      if (isFound) return;

      (this.form.get('imprese') as FormArray).push(
        this.fb.control(this.formRicercaImpresa.form.value)
      );
      this.impreseCantiereSelezionato.push(
        this.formRicercaImpresa.form.value
      );
    }

    console.log("this.impreseCantiereSelezionato:", this.impreseCantiereSelezionato);
    console.log("this.form.get('imprese'):", this.form.get('imprese'));

    this.formRicercaImpresa.reset();
    this.addingImpresa = false;
  }

  rimuoviImpresa(impresa: any) {
    this.impreseCantiereSelezionato = this.impreseCantiereSelezionato.filter(
      (imp: any) => imp !== impresa
    );
    this.form.setControl(
      'imprese',
      this.fb.array(this.impreseCantiereSelezionato)
    );
    console.log(this.form.value);
  }

  editCantiere(c: any, evt: Event){
    evt.preventDefault();
    console.log(c);
    this.openFormCantiere.emit(c);
  }

  deleteCantiere(c: any, evt: Event){
    evt.preventDefault();
    console.log(c);
    Swal.fire({
      title: 'Sei sicuro di voler eliminare il cantiere?',
      icon: 'warning',
      showDenyButton: true,
      confirmButtonText: 'Si',
      customClass: {
        confimButton: 'btn btn-outline-blue',
        denyButton: 'btn btn-outline-red',
      },
    }).then((res: any) => {
      if (res.isConfirmed) {
        this.is
          .deleteCantiere(c.id_cantiere)
          .subscribe(() =>{
            this.cantiereSelezionato = null;
            this.impreseCantiereSelezionato = null;
            this.ngOnInit();
          });
      }
    });
  }

  public get personeCantiere() {
    return this._personeCantiere;
  }
}
