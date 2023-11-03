import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import {NgbActiveModal, NgbModule} from '@ng-bootstrap/ng-bootstrap';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { VerbaliModule } from './verbali/verbali.module';
import { UtilsModule } from './utils/utils.module';
import { SpinnersAngularModule  } from 'spinners-angular';
import { LoginModule } from './login/login.module';
import { HeaderComponent } from './layout/header/header.component';
import { AFormModule } from './forms/a-form.module';
import { TokenInterceptor } from './http-interceptor';
import { FooterComponent } from './layout/footer/footer.component';
import { SupportoComponent } from './layout/supporto/supporto.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { SupportoService } from './layout/supporto/supporto.service';
import { ASmartTableModule } from './utils/modules/a-smart-table/a-smart-table.module';
import { ServiceWorkerModule } from '@angular/service-worker';
import { UserRoutingModule } from './user/user-routing.module';
import { UserModule } from './user/user.module';
import { HashLocationStrategy, LocationStrategy } from '@angular/common';

@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    FooterComponent,
    SupportoComponent,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    HttpClientModule,
    UserModule,
    AppRoutingModule,
    NgbModule,
    UtilsModule,
    SpinnersAngularModule,
    LoginModule,
    ASmartTableModule,
    AFormModule,
    ReactiveFormsModule,
    ServiceWorkerModule.register('ngsw-worker.js', {
      //enabled: environment.production,
      // Register the ServiceWorker as soon as the app is stable
      // or after 30 seconds (whichever comes first).
      registrationStrategy: 'registerWhenStable:30000'
    })
  ],
  providers: [
    NgbActiveModal,
    SupportoService,
    {
      provide: HTTP_INTERCEPTORS,
      useClass: TokenInterceptor,
      multi: true
    },
    {provide: LocationStrategy, useClass: HashLocationStrategy },
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
