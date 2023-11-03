import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ATemplateDirective } from './directives/a-template.directive';
import { AutofillerDirective } from './directives/autofiller.directive';
import { AMultiSelectComponent } from './components/a-multi-select/a-multi-select.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { AutoscrollDirective } from './directives/autoscroll.directive';
import { LoadingMessageComponent } from './components/loading-message/loading-message.component';
import { ErrorTipDirective } from './directives/error-tip.directive';
import { ItalianDatePipe } from './pipes/italian-date.pipe';
import { LoadingDialogComponent } from './components/loading-dialog/loading-dialog.component';
import { LoadingDialogService } from './services/loading-dialog-service/loading-dialog.service';
import { JsonParsePipe } from './pipes/json-parse.pipe';
import { NumberInputComponent } from './components/number-input/number-input.component';
import { FormsModule } from '@angular/forms';

@NgModule({
  declarations: [
    ATemplateDirective,
    AutofillerDirective,
    AutoscrollDirective,
    AMultiSelectComponent,
    LoadingMessageComponent,
    ErrorTipDirective,
    ItalianDatePipe,
    LoadingDialogComponent,
    JsonParsePipe,
    NumberInputComponent,
  ],
  imports: [
    CommonModule,
    FormsModule,
    NgbModule,
  ],
  exports: [
    NgbModule,
    ATemplateDirective,
    AutofillerDirective,
    AutoscrollDirective,
    AMultiSelectComponent,
    LoadingMessageComponent,
    ErrorTipDirective,
    ItalianDatePipe,
    JsonParsePipe,
    NumberInputComponent,
  ],
  providers: [
    LoadingDialogService
  ]
})
export class UtilsModule {}
