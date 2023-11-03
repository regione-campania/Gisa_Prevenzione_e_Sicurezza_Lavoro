import {
  AfterContentInit,
  Component,
  ContentChildren,
  OnInit,
  QueryList,
  ViewChild,
} from '@angular/core';
import { NgbCarousel } from '@ng-bootstrap/ng-bootstrap';
import { AContentPaginatorPageDirective } from './a-content-paginator-page.directive';

@Component({
  selector: 'a-content-paginator',
  templateUrl: './a-content-paginator.component.html',
  styleUrls: ['./a-content-paginator.component.scss'],
})
export class AContentPaginatorComponent implements OnInit, AfterContentInit {
  @ViewChild(NgbCarousel) carousel?: NgbCarousel;
  @ContentChildren(AContentPaginatorPageDirective)
  pages?: QueryList<AContentPaginatorPageDirective>;
  private _currentPageNumber = 1;

  constructor() {}

  ngOnInit(): void {}

  ngAfterContentInit(): void {
    let counter = 1;
    if (this.pages) {
      for (let p of this.pages) p.pageNumber = counter++;
    }
  }

  selectPage(input: HTMLInputElement) {
    if (!this.pages) return;
    let page = parseInt(input.value, 10) || 1;
    if (page === this.currentPageNumber) return;
    if (page > this.pages.length) this.currentPageNumber = this.pages.length;
    else if (page < 1) this.currentPageNumber = 1;
    else this.currentPageNumber = page;
    input.value = this.currentPageNumber.toString();
  }

  formatInput(input: HTMLInputElement) {
    input.value = input.value.replace(/[^0-9]/g, '');
  }

  //accessors
  public get currentPageNumber() {
    return this._currentPageNumber;
  }

  public set currentPageNumber(value) {
    this._currentPageNumber = value;
    this.carousel?.select('ngb-slide-' + (this._currentPageNumber - 1));
  }

  get currentPage() {
    return this.pages?.get(this.currentPageNumber - 1);
  }
}
