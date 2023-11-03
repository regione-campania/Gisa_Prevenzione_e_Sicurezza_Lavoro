import { animate, style, transition, trigger } from '@angular/animations';
import { Location } from '@angular/common';
import { Component, OnInit, TemplateRef, ViewChild } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { AppService } from 'src/app/app.service';
import { FormCantiereComponent } from 'src/app/forms/forms-prototypes/form-cantiere/form-cantiere.component';
import { FormIspezioneComponent } from 'src/app/forms/forms-prototypes/form-ispezione/form-ispezione.component';
import { FormRicercaCantiereComponent } from 'src/app/forms/forms-prototypes/form-ricerca-cantiere/form-ricerca-cantiere.component';
import { FormRicercaImpresaComponent } from 'src/app/forms/forms-prototypes/form-ricerca-impresa/form-ricerca-impresa.component';
import { IspezioniService } from '../ispezioni.service';

declare let Swal: any;

const ANIMATION_TIMING = '600ms cubic-bezier(0.33, 1, 0.68, 1)';

/** Editor Ispezione */
@Component({
  selector: 'editor-ispezione',
  templateUrl: './ispezione.component.html',
  styleUrls: ['./ispezione.component.scss'],
  animations: [
    trigger('formCantiereTrigger', [
      transition(':enter', [
        style({ left: '-100%', opacity: 0 }),
        animate(ANIMATION_TIMING, style({ left: 0, opacity: 1 })),
      ]),
      transition(':leave', [
        animate(ANIMATION_TIMING, style({ left: '-100%', opacity: 0 })),
      ]),
    ]),
    trigger('formImpresaTrigger', [
      transition(':enter', [
        style({ left: '100%', opacity: 0 }),
        animate(ANIMATION_TIMING, style({ left: 0, opacity: 1 })),
      ]),
      transition(':leave', [
        animate(ANIMATION_TIMING, style({ left: '100%', opacity: 0 })),
      ]),
    ]),
  ],
})
export class IspezioneComponent implements OnInit {
  @ViewChild('formIspezione') formIspezioneComponent?: FormIspezioneComponent;
  @ViewChild('formRicercaCantiere') formRicercaCantiere?: FormRicercaCantiereComponent;
  @ViewChild('formRicercaImpresa') formRicercaImpresa?: FormRicercaImpresaComponent;
  @ViewChild('modaleCantiere') templateModale?: TemplateRef<any>;
  @ViewChild(FormCantiereComponent) formCantiere?: FormCantiereComponent;

  nuovaIspezione: any;
  modalRef?: NgbModalRef;
  isEdit?: boolean | null;

  constructor(
    private ispService: IspezioniService,
    private fb: FormBuilder,
    private location: Location,
    private app: AppService,
    private route: ActivatedRoute,
    private router: Router,
    private modalService: NgbModal
  ) { }

  ngOnInit(): void {
    this.route.queryParams.subscribe((params: any) => {
      console.log("params:", params);
      if ('id' in params) {
        this.isEdit = true;
        this.app.pageName = 'Modifica ispezione';
        this.ispService.getIspezioneInfo(params.id).subscribe((isp) => {
          console.log(isp);
          this.nuovaIspezione = isp;
        });
      } else {
        this.isEdit = false;
        this.app.pageName = 'Nuova Ispezione';
        this.ispService.getNuovaIspezione(0).subscribe((ni: any) => {
          if (!ni.esito) {
            Swal.fire({ text: ni.msg, icon: 'error' });
            return;
          }
          this.ispService.getIspezioneInfo(ni.valore).subscribe((isp: any) => {
            console.log(isp);
            this.nuovaIspezione = isp;
          });
        });
      }
    });
  }

  openFormCantiere(c?: Event) {
    console.log("cantiere from parent:", c)
    if(c)
      localStorage.setItem('cantiereModal', JSON.stringify(c));
    this.modalRef = this.modalService.open(this.templateModale, {
      centered: true, size: 'fullscreen', windowClass: 'system-modal',
    });
  }

  onSubmit(ev: any) {
    this.formIspezioneComponent?.form.markAllAsTouched();
    ev.preventDefault();
    ev.stopPropagation();

    // Intera form dell'ispezione
    console.log("this.formIspezioneComponent?.form.value:", this.formIspezioneComponent?.form.value);

    // Form in alto a sinistra dell'impresa
    console.log("this.formRicercaImpresa?.form.value:", this.formRicercaImpresa?.form.value);

    // Form del cantiere
    console.log("this.formRicercaCantiere?.form.value:", this.formRicercaCantiere?.form.value);

    console.log("this.formIspezioneComponent?.form.value.imprese:", this.formIspezioneComponent?.form.value.imprese);
    console.log("this.formIspezioneComponent?.form.value.imprese[0].id:", this.formIspezioneComponent?.form.value.imprese[0]?.id);

    if (!this.isEdit) {
      if (this.formIspezioneComponent?.form.value.ispezione.cantiere_o_impresa.toUpperCase() == 'IMPRESA') {
        this.patchImprese(this.formRicercaImpresa?.form.value);
      } else {
        this.patchCantiere(this.formRicercaCantiere?.form.value);
      }
    }

    console.log("this.formIspezioneComponent?.form.value:", this.formIspezioneComponent?.form.value);

    if (this.formIspezioneComponent?.form.value.ispezione.id_servizio == null) {
      Swal.fire({
        text: "Selezionare il servizio.",
        icon: "warning",
      })
      return;
    }

    if (this.formIspezioneComponent?.form.value.ispezione.id_utente_access_congiunto == null) {
      Swal.fire({
        text: "Selezionare l'ispettore congiunto.",
        icon: "warning",
      })
      return;
    }

    console.log("this.formIspezioneComponent.form.value.ispezione.id_ambito", this.formIspezioneComponent.form.value.ispezione.id_ambito);
    if(this.formIspezioneComponent?.form.value.ispezione.id_ambito == "null")
      this.formIspezioneComponent.form.value.ispezione.id_ambito = null;
    console.log("this.formIspezioneComponent.form.value.ispezione.id_ambito", this.formIspezioneComponent.form.value.ispezione.id_ambito);
    /*if (this.formIspezioneComponent.ambitiIspettori.length > 0 && this.formIspezioneComponent?.form.value.ispezione.id_ambito == null) {
      Swal.fire({
        text: "Selezionare l'ambito.",
        icon: "warning",
      })
      return;
    }*/

    this.formIspezioneComponent!.form.value.ispezione.id_ente_uo_multiple = this.formIspezioneComponent?.data.ispezione.id_ente_uo_multiple
    console.log("this.formIspezioneComponent!.form.value.ispezione.id_ente_uo_multiple:", this.formIspezioneComponent!.form.value.ispezione.id_ente_uo_multiple);

    let entiCongiunti = this.formIspezioneComponent?.form.value.ispezione.id_ente_uo_multiple.map((e: any) => { return e.id_ente_uo != 'null' ? parseInt(e.id_ente_uo) : null });
    console.log(entiCongiunti)
    if (entiCongiunti.indexOf(null) > -1 || entiCongiunti.indexOf('null') > -1 || entiCongiunti.indexOf(NaN) > -1) {
      Swal.fire({
        text: `Specificare Ente congiunto`,
        icon: `warning`,
      })
      return;
    }
    
    if(entiCongiunti.some((val: any, i: number) => entiCongiunti.indexOf(val) !== i)) {
     
      Swal.fire({
        text: `Due o più Enti congiunti uguali`,
        icon: `warning`,
      })
      return;
    }

    if (entiCongiunti.indexOf(-1) > -1 &&
      (this.formIspezioneComponent?.form.value.ispezione.altro_ente == null ||
        this.formIspezioneComponent?.form.value.ispezione.altro_ente.trim().length == "")) {
      Swal.fire({
        text: `Specificare altro Ente congiunto`,
        icon: `warning`,
      })
      return;
    }

    if (this.formIspezioneComponent?.form.value.ispezione.id_motivo_isp == null) {
      Swal.fire({
        text: "Selezionare il motivo.",
        icon: "warning",
      })
      return;
    }

    if (this.formIspezioneComponent?.form.value.ispezione.id_motivo_isp == 2 &&
      (this.formIspezioneComponent?.form.value.ispezione.ente_richiedente == null ||
      this.formIspezioneComponent?.form.value.ispezione.ente_richiedente.trim().length == "")) {
      Swal.fire({
        text: "Specificare l'Ente Richiedente",
        icon: "warning",
      })
      return;
    }

    if (this.formIspezioneComponent?.form.value.ispezione.data_ispezione == null) {
      Swal.fire({
        text: "Selezionare la data dell'ispezione.",
        icon: "warning",
      })
      return;
    }

    if (this.formIspezioneComponent?.form.value.ispezione.id_stato_ispezione == -1) {
      Swal.fire({
        text: "Selezionare lo stato dell'ispezione.",
        icon: "warning",
      })
      return;
    }

    if (this.formIspezioneComponent?.form.value.ispezione.descr_isp.trim().length === 0) {
      Swal.fire({
        text: "Inserire descrizione.",
        icon: "warning",
      })
      return;
    }

    if (this.formIspezioneComponent?.form.value.ispezione.cantiere_o_impresa.toUpperCase() == 'CANTIERE') {
      if (!this.formIspezioneComponent?.form.value.ispezione.id_cantiere) {
        Swal.fire({
          text: `Accertarsi di aver selezionato un cantiere`,
          icon: 'warning',
        });
        return;
      }

      if (!this.formIspezioneComponent?.form.value.imprese || this.formIspezioneComponent?.form.value.imprese.length == 0) {
        Swal.fire({
          text: `Accertarsi di aver selezionato/inserito una o più imprese nel cantiere`,
          icon: 'warning',
        });
        return;
      }
    } else { //impresa
      console.log(this.formIspezioneComponent?.form.value);
      if (this.formIspezioneComponent?.form.value.imprese == null || 
        this.formIspezioneComponent?.form.value.imprese[0].nome_azienda == null || this.formIspezioneComponent?.form.value.imprese[0].nome_azienda.trim() == "" 
        )  {
        Swal.fire({
          text: `Accertarsi di aver inserito l'impresa`,
          icon: 'warning',
        });
        return;
      }

      /*if (this.formIspezioneComponent?.form.value.imprese[0].nome_azienda == null || this.formIspezioneComponent?.form.value.imprese[0].nome_azienda.trim() == "") {
        Swal.fire({
          text: `Accertarsi che l'impresa abbia il nome azienda (Ragione Sociale)`,
          icon: 'warning',
        });
        return;
      }*/

      
      if (
        (this.formIspezioneComponent?.form.value.imprese[0].partita_iva == null || this.formIspezioneComponent?.form.value.imprese[0].partita_iva.trim() == "")
        && (this.formIspezioneComponent?.form.value.imprese[0].codice_fiscale == null || this.formIspezioneComponent?.form.value.imprese[0].codice_fiscale.trim() == "")
        ) {
        Swal.fire({
          text: `Accertarsi che l'impresa abbia la partita IVA e/o codice fiscale!`,
          icon: 'warning',
        });
        return;
      }
      
    }

    this.insertIspezione();
  }

  patchCantiere(patch: any) {
    console.log(patch);
    this.formIspezioneComponent?.form
      .get('cantiere')
      ?.patchValue(patch.cantiere);
    this.formIspezioneComponent?.form
      .get('ispezione')
      ?.patchValue(patch.cantiere);
    this.patchImprese(patch.imprese);
  }

  patchImprese(patch: any) {
    console.log(patch);
    const impresaModel = Object.assign(this.nuovaIspezione.imprese[0]);
    const formArray = this.fb.array([]);
    let newControl;
    if (Array.isArray(patch)) {
      patch.forEach((p: any) => {
        newControl = this.fb.group(impresaModel);
        newControl.patchValue(p);
        formArray.push(newControl);
      });
    } else {
      newControl = this.fb.group(impresaModel);
      newControl.patchValue(patch);
      formArray.push(newControl);
    }
    this.formIspezioneComponent?.form.setControl('imprese', formArray);
  }

  insertIspezione() {
    console.log("--------Insert ispezione------");
    console.log(this.formIspezioneComponent?.form.value);
    this.ispService
      .updateIspezione(this.formIspezioneComponent?.form.value)
      .subscribe((ret: any) => {
        if (!ret.esito) {
          Swal.fire({ text: ret.msg.split(' [')[0], icon: 'warning' });
          return;
        } else {
          this.goToListaIspezioni();
          var testo = "";
          if (this.app.pageName == "Nuova Ispezione")
            testo = 'Nuova Ispezione creata con successo!';
          else
            testo = 'Modifica avvenuta con successo!';

          Swal.fire({
            text: testo,
            icon: 'success',
          });
        }
      });
  }

  reload() {
    this.formRicercaCantiere?.reloadCantieri();
  }

  goToListaIspezioni(){
    console.log(this.nuovaIspezione)
    this.router.navigate(['/ispezioni', {reopen: this.nuovaIspezione.ispezione.id}])
  }
}
