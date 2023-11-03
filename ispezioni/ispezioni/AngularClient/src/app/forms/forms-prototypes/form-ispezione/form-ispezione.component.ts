import { AfterViewInit, Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { AnagraficaService } from 'src/app/anagrafica/anagrafica.service';
import { AppService } from 'src/app/app.service';
import { IspezioniService } from 'src/app/user/ispezioni/ispezioni.service';
import { UserService } from 'src/app/user/user.service';
import { AbstractForm } from '../abstract-form';

@Component({
  selector: 'form-ispezione',
  templateUrl: './form-ispezione.component.html',
  styleUrls: ['./form-ispezione.component.scss'],
})
export class FormIspezioneComponent extends AbstractForm implements OnInit, AfterViewInit {
  name = 'formIspezione';

  ispettori: any;
  ispettoriServizio: any;
  entiUopTree: any;
  entiUopTreeChildren: any;
  aslPerContoDi: any;
  aslPerContoDiChildren: any;
  motivi: any;
  asl: any;
  servizi: any;
  pageName: any;
  ambiti: any[] = [];
  ambitiIspettori: any[] = [];
  ambitoUtenteCorrente: any;
  private _isFutureDate?: boolean;
  private _altriIspettori: any[] = [];
  private _ngSelected?: any;

  constructor(
    protected override fb: FormBuilder,
    private anagrafiche: AnagraficaService,
    private ispezioni: IspezioniService,
    private us: UserService,
    private app: AppService
  ) {
    super(fb);
  }

  ngOnInit(): void {
    this.pageName = this.app.pageName;
    console.log(this.data);

    this.anagrafiche.getEntiUnitaOperativeTree().subscribe((res) => {
      this.entiUopTree = res;
      this.aslPerContoDi = res;

      this.entiUopTree = this.entiUopTree.filter(
        (ente: any) => ente.id_asl === null
      );
      this.entiUopTreeChildren = this.entiUopTree.flatMap(
        (ente: any) => ente.children
      );

      this.aslPerContoDi = this.aslPerContoDi.filter(
        (ente: any) => ente.id_asl !== null
      );
      this.aslPerContoDiChildren = this.aslPerContoDi.flatMap(
        (ente: any) => ente.children
      );

      console.log(this.aslPerContoDi);
    });

    this.us.user.subscribe((user) => {
      console.log('--------get user info----------');
      console.log(user);
      this.ambitoUtenteCorrente = user.idAmbito;
      this.anagrafiche.getAsl().subscribe((asl: any) => {
        this.asl = asl.filter((a: any) => a.code == user.idAslUtente);
        this.form
          .get('ispezione')
          ?.patchValue({ per_conto_di: user.idAslUtente });
      });
      this.anagrafiche.getServizi().subscribe((servizi: any) => {
        let servizio = '';
        if (user.ruoloUtente.includes('SIML')) servizio = 'SIML';
        else if (user.ruoloUtente.includes('SPSAL')) servizio = 'SPSAL';
        this.servizi = servizi.filter((s: any) => s.descr.includes(servizio));
      });
      this.form
        .get('ispezione')
        ?.patchValue({ id_utente_access: user.idUtente });

      this.ispezioni.getIspettoriAsl().subscribe((res) => {
        this.ispettori = res;

        console.log(this.ispettori)
        this.ispettori.forEach((isp: any) => {
          if (isp.ambito && !this.ambiti.find((am1: any) => { return am1.id_ambito == this.ispettori.map((am2: any) => { return am2.id_ambito }) })) {
            console.log(isp);
            this.ambiti.push({ id_ambito: isp.id_ambito, ambito: isp.ambito });
          }
        });
        console.log(this.ambiti)
        // Elimina se stesso dalla lista degli ispettori
        this.ispettori = this.ispettori.filter((isp: any) => isp.codice_fiscale != user.cf);
        console.log("this.ispettori:", this.ispettori);

      });
    });

    this.ispezioni.getMotiviIspezione().subscribe((motivi) => {
      this.motivi = motivi;
      this.motivi.sort((a: any, b: any) => {
        return a.descr > b.descr ? 1 : a.descr < b.descr ? -1 : 0;
      });
    });

    if (this.data.ispezione.data_ispezione != null)
      this.data.ispezione.data_ispezione =
        this.data.ispezione.data_ispezione.split('T')[0];

    this.form = this.fb.group({
      cantiere: this.fb.group(this.data.cantiere),
      fasi: this.fb.array(this.data.fasi),
      imprese: this.fb.array(this.data.imprese),
      ispezione: this.fb.group(this.data.ispezione),
      nucleo_ispettivo: this.fb.array(this.data.nucleo_ispettivo),
      stati_ispezione_successivi: this.fb.array(
        this.data.stati_ispezione_successivi
      ),
    });

    Object.keys((this.form.controls['ispezione']! as FormGroup).controls).forEach(key => {
      //console.log('ispezione', key);
      if(['luogo', 'note', 'id_ambito'].indexOf(key) < 0){
        (this.form.controls['ispezione']! as FormGroup).controls[key].setValidators(Validators.required)
        console.log((this.form.controls['ispezione']! as FormGroup).controls[key])
      }
    });
    
  }

  override ngAfterViewInit(): void {
    console.log("this.data.stati_ispezione_successivi:", this.data.stati_ispezione_successivi);
    this.data.stati_ispezione_successivi = this.data.stati_ispezione_successivi.filter((elem: any) => {
      return elem.descr_stato_ispezione_prossimo != 'PROGRAMMATA';
    })

    let idEntiPreselezionati = this.data.ispezione.id_ente_uo_multiple;
    /*this.form.value.ispezione.id_ente_uo_multiple = [];
    idEntiPreselezionati.forEach((e: any) => {
      this.form.value.ispezione.id_ente_uo_multiple.push({id_ispezione: this.data.ispezione.id, id_ente_uo: e.id_ente_uo})
    })
    console.log(this.form.value.ispezione.id_ente_uo_multiple)*/

  }

  findEnteById(id: any) {
    return this.entiUopTreeChildren.find((ente: any) => ente.id_ente_uo == id);
  }

  findMotivoById(id: any) {
    console.log(id);
    if(id.split(": ").length > 1) { //se multiple
      id = parseInt(id.split(": ")[1].replace(/'/g, ''))
    }
    return this.motivi.find((motivo: any) => motivo.id_motivo_isp == id);
  }

  findStatoById(id: any) {
    return this.data.stati_ispezione_successivi.find((stato: any) => {
      stato.id_stato_ispezione_prossimo == id
    });
  }

  checkEnteValue(enteValue: any) {
    return true ? parseInt(enteValue) == -1 : false;
  }

  checkEnteValueMultiple() {
    return this.data.ispezione.id_ente_uo_multiple.map((i: any) => { return parseInt(i.id_ente_uo) }).indexOf(-1) >= 0;
  }

  // Controlla se Motivo == VIGILANZA SU RICHIESTA (id = 2)
  checkEnteRichiedente(motivoValue: any) {
    return true ? parseInt(motivoValue) == 2 : false;
  }

  patchEnteCongiuntoMultiple(uo: any, i:number) {
    console.log(uo, i);
    this.data.ispezione.id_ente_uo_multiple[i] = {id_ispezione: this.data.ispezione.id, id_ente_uo: uo};
    console.log(this.data.ispezione.id_ente_uo_multiple);
    //this.form.value.ispezione.id_ente_uo_multiple = this.data.ispezione.id_ente_uo_multiple;
    //console.log(this.form.value.ispezione.id_ente_uo_multiple);
  }

  aggiornaIspettori(el: any) {
    let mioAmbito = this.ambiti.find((a: any) => {
      return a.id_ambito == this.ambitoUtenteCorrente;
    })
    console.log("mioAmbito:", mioAmbito);

    if (mioAmbito)
      this.ambitiIspettori = [mioAmbito]
    console.log("this.ambitiIspettori:", this.ambitiIspettori);
    
    let servizioSelezionato = this.servizi.find((s: any) => {
      return s.id == el;
    })
    servizioSelezionato = servizioSelezionato.descr.split(' ');
    console.log("servizioSelezionato:", servizioSelezionato);
    
    console.log("this.ispettori:", this.ispettori)
    // this.ispettoriServizio = this.ispettori.find((i: any) => {
    //   console.log("i:", i);
    //   for (let j = 0; j < servizioSelezionato.length; j++) {
    //     return i.ruolo.includes(servizioSelezionato[j]);
    //   }
    // });

    this.ispettoriServizio = [];
    this.ispettori.forEach((i: any) => {
      for (let j = 0; j < servizioSelezionato.length; j++) {
        if (i.ruolo.toUpperCase().replace("ISPETTORE", '').trim().includes(servizioSelezionato[j])) {
          this.ispettoriServizio.push(i);
        }
      }
    })
    console.log("this.ispettoriServizio:", this.ispettoriServizio);

    if (typeof this.ispettoriServizio == 'object')
      this.ispettoriServizio = [this.ispettoriServizio];

    // Lista ispettori associati
    this._altriIspettori = [];
    let descrApp;
    this.ispettoriServizio[0].forEach((ispettore: any) => {
      ispettore.ambito == null ? descrApp = `${ispettore.cognome} ${ispettore.nome} - ${ispettore.ruolo}` : descrApp = `${ispettore.cognome} ${ispettore.nome} - ${ispettore.ruolo} - ${ispettore.ambito}`;
      this._altriIspettori.push({
        user_id: ispettore.user_id,
        descr: descrApp
      });
    });

    if (this._altriIspettori.length > 0) {
      this._ngSelected = this._altriIspettori[0].user_id;
      this.patchValue('ispezione.id_utente_access_congiunto', this._altriIspettori[0].user_id);
    }

    this.aggiornaAmbiti(this._altriIspettori[0].user_id);

    console.log("this._altriIspettori:", this._altriIspettori);

    console.log("this.form", this.form);
  }

  aggiornaAmbiti(idCongiunto: any) {
    this.ambitiIspettori = [];
    console.log("this.ambitoUtenteCorrente", this.ambitoUtenteCorrente);
    if(this.ambitoUtenteCorrente){
      this.ambitiIspettori = [this.ambiti.find((a: any) => {
        return a.id_ambito == this.ambitoUtenteCorrente;
      })]
    }
    console.log("idCongiunto:", idCongiunto);
    console.log(this.ispettoriServizio)
    let congiunto = this.ispettoriServizio[0].find((c: any) => {
      return c.user_id == idCongiunto;
    })
    console.log(congiunto);
    let ambitoCogiunto = this.ambiti.find((a: any) => {
      return a.id_ambito == congiunto.id_ambito;
    })
    if (ambitoCogiunto && ambitoCogiunto.id_ambito != this.ambitoUtenteCorrente)
      this.ambitiIspettori.push(ambitoCogiunto);

  }

  changeStatoIspezione() {
    const chosenDate = new Date(this.form.value.ispezione.data_ispezione);
    const currentDate = new Date();

    if (chosenDate.getTime() > currentDate.getTime()) {
      this._isFutureDate = true;
      this.patchValue('ispezione.descr_stato_ispezione', 'PROGRAMMATA');
      this.patchValue('ispezione.id_stato_ispezione', 4);
    } else {
      this._isFutureDate = false;
      this.patchValue('ispezione.descr_stato_ispezione', 'IN CORSO');
      this.patchValue('ispezione.id_stato_ispezione', 1);
    }
  }

  addEnteCongiunto(ev: Event){
    console.log("CLICK addEnteCongiunto");
    ev.preventDefault();
    this.data.ispezione.id_ente_uo_multiple.push({id_ispezione: this.data.ispezione.id, id_ente_uo: "null"});
    //this.form.value.ispezione.id_ente_uo_multiple = this.data.ispezione.id_ente_uo_multiple;
  }

  removeEnteCongiunto(ev: Event, i: number){
    console.log("remove addEnteCongiunto");
    ev.preventDefault();
    this.data.ispezione.id_ente_uo_multiple.splice(i, 1);
    //this.form.value.ispezione.id_ente_uo_multiple = this.data.ispezione.id_ente_uo_multiple;
  }

  public get isFutureDate() {
    return this._isFutureDate;
  }

  public get altriIspettori() {
    return this._altriIspettori;
  }

  public get ngSelected() {
    return this._ngSelected;
  }
}
