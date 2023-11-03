import { Component } from '@angular/core';
import { Verbale } from '../verbale.abstract';

@Component({
  selector: 'verbale-di-sopralluogo',
  templateUrl: './verbale-di-sopralluogo.component.html',
  styleUrls: ['./verbale-di-sopralluogo.component.scss']
})
export class VerbaleDiSopralluogoComponent extends Verbale {
  override idModulo = '1';

  get isDittaOCantiere() {
    return this.form.get('is_ditta_o_cantiere')?.value;
  }

}
