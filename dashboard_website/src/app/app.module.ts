import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './login/login.component';
import { ReactiveFormsModule } from '@angular/forms';
import { SignupComponent } from './signup/signup.component';
import { HttpClientModule } from '@angular/common/http';
import { HomeComponent } from './home/home.component';
import { CoursesComponent } from './courses/courses.component';
import { NotificationComponent } from './notification/notification.component';
<<<<<<< HEAD
import { MDBBootstrapModule } from 'angular-bootstrap-md';

=======
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatToolbarModule } from  '@angular/material/toolbar';
>>>>>>> 8485edf7dcb127101c3a1b8edd444b5a1afd61ba
@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    SignupComponent,
    HomeComponent,
    CoursesComponent,
    NotificationComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    ReactiveFormsModule,
    HttpClientModule,
<<<<<<< HEAD
    MDBBootstrapModule.forRoot(),
=======
    MatToolbarModule,
    BrowserAnimationsModule,
>>>>>>> 8485edf7dcb127101c3a1b8edd444b5a1afd61ba
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
