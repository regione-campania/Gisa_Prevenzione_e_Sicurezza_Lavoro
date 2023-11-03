import { Directive } from "@angular/core";
import { AbstractForm } from "src/app/forms/forms-prototypes/abstract-form";

@Directive()
export abstract class Verbale extends AbstractForm {
  idModulo?: string | number;
  idVerbale?: string | number;
  idIspezioneFase?: string | number;
}
