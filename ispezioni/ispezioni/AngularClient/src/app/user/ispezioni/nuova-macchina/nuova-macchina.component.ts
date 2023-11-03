import { FormArray, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { AFormService } from 'src/app/forms/a-form-service';
import { Location } from '@angular/common';
import { AfterViewInit, Component, OnInit } from '@angular/core';
import { AbstractForm } from 'src/app/forms/forms-prototypes/abstract-form';
import { MacchineService } from '../macchine.service';

declare let Swal: any;

@Component({
  selector: 'app-nuova-macchina',
  templateUrl: './nuova-macchina.component.html',
  styleUrls: ['./nuova-macchina.component.scss']
})
export class NuovaMacchinaComponent extends AbstractForm implements OnInit, AfterViewInit {

  tipiMacchine: any;
  costruttori: any;
  private file!: File | null; // Variable to store file

  override form = this.fb.group({
    descr_tipo_macchina: this.fb.control('', [Validators.required]),
    descr_costruttore: this.fb.control('', [Validators.required]),
    modello: this.fb.control('', [Validators.required])
  });

  constructor(
    protected override fb: FormBuilder,
    public ms: MacchineService,
    private location: Location,
  ) {
    super(fb);
  }

  ngOnInit(): void {
    this.ms.getTipiMacchine().subscribe((res) => {
      this.tipiMacchine = res;
    })

    this.ms.getCostruttori().subscribe((res) => {
      this.costruttori = res;
    })

    this.file = null;
  }

  allegaInfo(evt: any) {
    this.file = evt.target.files[0];
    console.log("file:", this.file);
  }

  patchCostruttore(costr: any) {
    let cos = this.costruttori.find((c: any) => c.descr_costruttore === costr);
    if (cos) {
      let patch = {
        descr_costruttore: cos.descr_costruttore
      };
      this.form.patchValue(patch);
    }
  }

  patchTipoMacchina(tipoMacchina: any) {
    let mac = this.tipiMacchine.find((m: any) => m.descr_tipo_macchina === tipoMacchina);
    if (mac) {
      let patch = {
        descr_tipo_macchina: mac.descr_tipo_macchina
      };
      this.form.patchValue(patch);
    }
  }

  override submit(): void {
    console.log("this.form.value:", this.form.value);

    if (this.form.value.descr_tipo_macchina == null || this.form.value.descr_tipo_macchina.trim() == ''){
      Swal.fire({
        text: 'Selezionare il tipo macchina!',
        icon: 'warning',
      });
      return;
    }

    if (this.form.value.descr_costruttore == null || this.form.value.descr_costruttore.trim() == ''){
      Swal.fire({
        text: 'Inserire il costruttore!',
        icon: 'warning',
      });
      return;
    }

    if (this.form.value.modello == null || this.form.value.modello.trim() == ''){
      Swal.fire({
        text: 'Inserire il modello!',
        icon: 'warning',
      });
      return;
    }

    if (this.file == null){
      Swal.fire({
        text: 'Inserire il file!',
        icon: 'warning',
      });
      return;
    }

    this.ms.updMacchine(JSON.stringify(this.form.value), this.file!, this.file!.name).subscribe((ret: any) => {
      console.log("ret:", ret);
      if (ret.esito) {
        Swal.fire({
          text: "Inserimento avvenuto con successo!",
          icon: "success"
        });
        this.location.back();
      } else {
        Swal.fire({
          text: "Errore durante l'inserimento!",
          icon: "warning"
        });
      }
    },
    (err) => {
      Swal.fire({
        text: "Errore nel salvataggio! Verificare che non esista una macchina con stesso Tipo, Costruttore e Modello",
        icon: "error"
      });
    });
  }
}
