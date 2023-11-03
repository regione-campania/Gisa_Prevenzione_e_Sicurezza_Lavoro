import { Component, ElementRef, Input, OnInit } from '@angular/core';

@Component({
  selector: 'loading-dialog',
  templateUrl: './loading-dialog.component.html',
  styleUrls: ['./loading-dialog.component.scss']
})
export class LoadingDialogComponent implements OnInit {
  @Input() message: string = 'Caricamento in corso...';
  @Input() optionalInfo?: string;

  constructor(private elementRef: ElementRef) {}

  ngOnInit(): void {
  }

  get htmlElement() {
    return this.elementRef.nativeElement as HTMLElement;
  }

}
