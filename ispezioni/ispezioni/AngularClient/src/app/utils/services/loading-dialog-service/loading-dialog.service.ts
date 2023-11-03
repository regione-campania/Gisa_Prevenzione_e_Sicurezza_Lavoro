import { Injectable } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { LoadingDialogComponent } from '../../components/loading-dialog/loading-dialog.component';

@Injectable({
  providedIn: 'root',
})
export class LoadingDialogService {
  private _modal?: NgbModalRef;

  constructor(private modalService: NgbModal) {}

  openDialog(message?: string, optionalInfo?: string) {
    this._modal = this.modalService.open(LoadingDialogComponent, {
      backdrop: 'static', centered: true, modalDialogClass: 'loading-dialog-modal',
      animation: false, keyboard: false
    });
    let componentInstance = this._modal.componentInstance as LoadingDialogComponent;
    if (message) componentInstance.message = message;
    if (optionalInfo) componentInstance.optionalInfo = optionalInfo;
  }

  closeDialog() {
    this._modal?.close();
  }

  hasOpenDialog() {
    return this.modalService.hasOpenModals();
  }

  setMessage(message: string) {
    this.dialog.message = message;
  }

  setOptionalInfo(info: string) {
    this.dialog.optionalInfo = info;
  }

  showSpinner() {
    let spinner = this.dialog.htmlElement.querySelector('#spinner-container') as HTMLElement;
    if (spinner) spinner.hidden = false;
  }

  hideSpinner() {
    let spinner = this.dialog.htmlElement.querySelector('#spinner-container') as HTMLElement;
    if (spinner) spinner.hidden = true;
  }

  //accessors
  get modal() {
    return this._modal;
  }

  get dialog() {
    return this._modal?.componentInstance as LoadingDialogComponent;
  }
}
