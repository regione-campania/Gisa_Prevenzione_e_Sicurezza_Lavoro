import {
  AfterViewInit,
  Directive,
  EventEmitter,
  HostListener,
  Input,
  Output,
} from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';

declare let Swal: any;

@Directive()
export abstract class AbstractForm implements AfterViewInit {
  @Input() showButton = true; //indicates whether to show submit button or not
  @Input() buttonLabel = 'Salva'; //submit button inner text
  @Input() data?: any;  //optional data
  @Output('onSubmit') submitEvent = new EventEmitter<any>();

  form = this.fb.group({});

  constructor(protected fb: FormBuilder) {}

  ngAfterViewInit(): void {
    //fix for datepickers
    const datepickers = document.querySelectorAll('input[type=date]');
    datepickers?.forEach((dp: any) => {
      dp.addEventListener('click', () => dp.showPicker());
    });
  }

  //Wraps AbstractControl.patchValue. Useful when used in templates.
  patchValue(controlPath: any, value: any) {
    this.form.get(controlPath)?.patchValue(value);
  }

  submit() {
    this.form.markAllAsTouched();
    console.log("this.form.value:", this.form.value);

    if (this.form.value.fase.id_impresa_sede == null) {
      /*Swal.fire({
        text: "Selezionare impresa",
        icon: "warning",
      })
      return;*/
    }

    if (this.form.value.fase.id_impresa_sede == "null") {
      this.form.value.fase.id_impresa_sede = null;
      /*Swal.fire({
        text: "Selezionare impresa",
        icon: "warning",
      })
      return;*/
    }
    
    if (this.form.value.fase.id_fase_esito == null) {
      Swal.fire({
        text: "Selezionare la fase.",
        icon: "warning",
      })
      return;
    }

    if (this.form.value.fase.data_fase == null) {
      Swal.fire({
        text: "Selezionare la data.",
        icon: "warning",
      })
      return;
    }

    /*if (this.form.value.fase.id_fase_esito == 2 &&
      (this.form.value.fase.altro_esito == null ||
        this.form.value.fase.altro_esito.trim().length === 0)
    ) {
      Swal.fire({
        text: "Inserire Altro.",
        icon: "warning",
      })
      return;
    }*/
    this.submitEvent.emit(this.form.value);
  }
}
