import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators} from '@angular/forms';
import { SupportoService} from './supporto.service';
declare let Swal: any

@Component({
  selector: 'app-supporto',
  templateUrl: './supporto.component.html',
  styleUrls: ['./supporto.component.scss']
})
export class SupportoComponent implements OnInit {

  formSupporto = this.formBuilder.group({
    nomeSegnalante: this.formBuilder.control('', Validators.required),
    emailSegnalante: this.formBuilder.control('', Validators.pattern("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$")),
    telefonoSegnalante: this.formBuilder.control('', Validators.pattern(/\d+/)),
    titolo: this.formBuilder.control('', Validators.required),
    messaggio: this.formBuilder.control('', Validators.required),
    tipo: this.formBuilder.control('', Validators.required),
    ente: this.formBuilder.control('', Validators.required)
  });

  constructor(
    private formBuilder: FormBuilder,
    private ss: SupportoService
  ) { }

  ngOnInit(): void {
  }

  onSubmit(): void{
    this.formSupporto.markAllAsTouched();
    let valori = this.formSupporto.value;
    console.log(valori)
    if(valori.tipo.trim() == ''){
      Swal.fire({ text: "Valorizzare tipo problema!", icon: 'warning' });
      return;    
    }
    if(valori.titolo.trim() == ''){
      Swal.fire({ text: "Valorizzare titolo!", icon: 'warning' });
      return;    
    }
    if(valori.messaggio.trim() == ''){
      Swal.fire({ text: "Valorizzare descrizione problema!", icon: 'warning' });
      return;    
    }
    if(valori.nomeSegnalante.trim() == ''){
      Swal.fire({ text: "Valorizzare nome e cognome!", icon: 'warning' });
      return;    
    }
    if(valori.telefonoSegnalante.trim() == '' && valori.emailSegnalante.trim() == ''){
      Swal.fire({ text: "Valorizzare almeno uno tra email e telefono di ricontatto!", icon: 'warning' });
      return;    
    }
    if(this.formSupporto.controls['emailSegnalante'].invalid){
      Swal.fire({ text: "Formato email non valido!", icon: 'warning' });
      return;
    }
    if(this.formSupporto.controls['telefonoSegnalante'].invalid){
      Swal.fire({ text: "Formato telefono non valido!", icon: 'warning' });
      return;
    }
    if(valori.ente.trim() == ''){
      Swal.fire({ text: "Valorizzare ente di appartenenza!", icon: 'warning' });
      return;    
    }
    try{
      this.ss.sendEmail(this.formSupporto.value).subscribe();
      Swal.fire({ text: "Messaggio inoltrato con successo!", icon: 'success' });
      //this.formSupporto.resetForm();
    }catch(err){
      Swal.fire({ text: "Errore nell'inoltro della segnalazione", icon: 'error' });
      return;
    }
  }

}
