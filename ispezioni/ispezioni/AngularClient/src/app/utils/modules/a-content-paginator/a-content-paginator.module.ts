import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AContentPaginatorComponent } from './a-content-paginator.component';
import { AContentPaginatorPageDirective } from './a-content-paginator-page.directive';
import { NgbCarouselModule, NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';
import { FormsModule } from '@angular/forms';



@NgModule({
  declarations: [
    AContentPaginatorComponent,
    AContentPaginatorPageDirective,
  ],
  imports: [
    CommonModule,
    FormsModule,
    NgbPaginationModule,
    NgbCarouselModule,
  ],
  exports: [
    AContentPaginatorComponent,
    AContentPaginatorPageDirective,
  ]
})
export class AContentPaginatorModule { }
