import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { AbstractForm } from '../abstract-form';
import { AnagraficaService } from 'src/app/anagrafica/anagrafica.service';

@Component({
  selector: 'form-ricerca-impresa',
  templateUrl: './form-ricerca-impresa.component.html',
  styleUrls: ['./form-ricerca-impresa.component.scss']
})
export class FormRicercaImpresaComponent extends AbstractForm implements OnInit {

  @Input() header = 'Impresa'

  name = 'formRicercaImpresa'
  imprese: any
  impresaSelezionata: any

  constructor(protected override fb: FormBuilder, private anagrafiche: AnagraficaService) {
    super(fb);
  }

  ngOnInit(): void {
    console.log("----- Form Ricerca Impresa -----");
    console.log("this.data.imprese:", this.data?.imprese);
    // Impresa già presente se sono in modalità modifica
    if (this.data?.imprese[0].id != null){
      console.log("Modifica Ispezione!")
      this.selezionaImpresa(this.data?.imprese[0])
    }
    else {
      this.reset()
      this.anagrafiche.getImpreseSedi().subscribe(res => {
        this.imprese = res
      })
    }
  }

  selezionaImpresa(impresa: any) {
    this.impresaSelezionata = impresa
    console.log(impresa)
    this.form = this.fb.group(this.impresaSelezionata)
  }

  reset() {
    this.impresaSelezionata = null
    this.form = this.fb.group({nome_azienda: '', partita_iva: '', codice_fiscale: ''})
  }

}
