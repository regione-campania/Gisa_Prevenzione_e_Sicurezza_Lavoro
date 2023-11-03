import { Component, ComponentRef, Input, OnInit, ViewContainerRef } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { RichiestaDocumentaleAziendeComponent } from './richiesta-documentale-aziende/richiesta-documentale-aziende.component';
import { RichiestaDocumentaleCantieriComponent } from './richiesta-documentale-cantieri/richiesta-documentale-cantieri.component';
import { VerbaleDiAccertamentoComponent } from './verbale-di-accertamento/verbale-di-accertamento.component';
import { VerbaleDiPrescrizioneEContestualeAccertamentoComponent } from './verbale-di-prescrizione-e-contestuale-accertamento/verbale-di-prescrizione-e-contestuale-accertamento.component';
import { VerbaleDiPrescrizioneComponent } from './verbale-di-prescrizione/verbale-di-prescrizione.component';
import { VerbaleDiSommarieInformazioniTestimonialiComponent } from './verbale-di-sommarie-informazioni-testimoniali/verbale-di-sommarie-informazioni-testimoniali.component';
import { VerbaleDiSpontaneeDichiarazioniComponent } from './verbale-di-spontanee-dichiarazioni/verbale-di-spontanee-dichiarazioni.component';
import { VerbaleSequestroPreventivoComponent } from './verbale-sequestro-preventivo/verbale-sequestro-preventivo.component';
import { VerbaleSequestroProbatorioComponent } from './verbale-sequestro-probatorio/verbale-sequestro-probatorio.component';
import { Verbale } from './verbale.abstract';
import { VerbaliService } from './verbali.service';

declare let Swal: any;

/** Componente che racchiude tutti i verbali. Cambia forma in base all'idModulo */
@Component({
  selector: 'app-verbali',
  templateUrl: './verbali.component.html',
  styleUrls: ['./verbali.component.scss']
})
export class VerbaliComponent extends Verbale implements OnInit {
  /** Identifica un tipo di verbale */
  @Input() override idModulo?: string | number;
  /** Se vuoto verrà creato un nuovo verbale, altrimenti verrà modificato uno esistente  */
  @Input() override idVerbale?: string | number;
  /** ID della fase di un'ispezione a cui allegare il verbale */
  @Input() override idIspezioneFase?: string | number;

  componentRef?: ComponentRef<Verbale>;

  constructor(
    protected vs: VerbaliService,
    protected override fb: FormBuilder,
    protected viewContainer: ViewContainerRef,
  ) {
    super(fb);
  }

  ngOnInit(): void {
    //istanzia il componente relativo al verbale in base all'idModulo
    this._createComponent();
    if (this.idVerbale) {
      this.vs.getJsonVerbale(this.idVerbale!).subscribe((json) => {
        this.form.patchValue(json.dati);
      });
    }
  }

  private _createComponent() {
    let t: any;
    switch(+this.idModulo!) { //parses idModulo to a number
      case 1: case 11: t = RichiestaDocumentaleAziendeComponent; break;
      case 2: case 12: t = RichiestaDocumentaleCantieriComponent; break;
      case 3: case 13: t = VerbaleDiPrescrizioneComponent; break;
      case 4: case 14: t = VerbaleDiAccertamentoComponent; break;
      case 5: case 15: t = VerbaleDiPrescrizioneEContestualeAccertamentoComponent; break;
      case 6: case 16: t = VerbaleSequestroPreventivoComponent; break;
      case 7: case 17: t = VerbaleSequestroProbatorioComponent; break;
      case 8: case 18: t = VerbaleDiSommarieInformazioniTestimonialiComponent; break;
      case 9: case 19: t = VerbaleDiSpontaneeDichiarazioniComponent; break;
    }
    this.componentRef = this.viewContainer.createComponent(t);
    this.componentRef.instance.idModulo = this.idModulo;
    this.componentRef.instance.idVerbale = this.idVerbale;
    this.componentRef.instance.idIspezioneFase = this.idIspezioneFase;
    this.form = this.componentRef.instance.form;
    this.componentRef.instance.submitEvent.subscribe(formValue => {
      this.form.patchValue(formValue);
      this.submit();
    })
  }

  override submit(): void {
    console.log(this.form.value);
    this.vs
      .setJsonVerbale(
        this.form.value,
        this.idVerbale,
        this.idModulo,
        this.idIspezioneFase
      )
      .subscribe((res: any) => {
        console.log(res);
        if (!res.esito) {
          Swal.fire({
            text: 'Errore in fase di salvataggio',
            icon: 'error',
          });
        }
      });
    this.submitEvent.emit(this.form.value);
  }
}
