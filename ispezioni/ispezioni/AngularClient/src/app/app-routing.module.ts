import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { InformativaComponent } from './login/informativa/informativa.component';
import { SupportoComponent } from './layout/supporto/supporto.component';
import { AuthGuard } from './guards/auth.guard';
import { UserComponent } from './user/user.component';
import { LoginGuard } from './guards/login.guard';
import { TrasferimentoIspezioniComponent } from './user/ispezioni/trasferimento-ispezioni/trasferimento-ispezioni.component';

const routes: Routes = [
  { path: 'informativa', component: InformativaComponent },
  { path: 'supporto', component: SupportoComponent },
  { path: 'login', component: LoginComponent, canActivate: [LoginGuard] },
  { path: 'dashboard', component: UserComponent, canActivate: [AuthGuard] },
  { path: '', redirectTo: '/login', pathMatch: 'full' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
