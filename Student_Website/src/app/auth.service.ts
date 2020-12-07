import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Data } from './data';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  str: string ="";
  httpheaders:any;
  constructor(private http: HttpClient ) {}
  RegisterUser(data: any): Observable<any>{
    return this.http.post('https://notifyme69.herokuapp.com/api/register/app/',data);
  }
  LoginUser(data : any): Observable<any>{
    return this.http.post('https://notifyme69.herokuapp.com/api/login/app/',data); 
  }
  CoursesList(data:any): Observable<any>{
    this.str='Token '+sessionStorage.getItem('token');
    this.httpheaders = new HttpHeaders({
      'Content-Type':  'application/json',
      'Authorization': this.str
  });
    return this.http.post('https://notifyme69.herokuapp.com/api/inst/get_courses/',data,{headers : this.httpheaders});
  }
  addCourse(data:any): Observable<any>{
    this.str='Token '+sessionStorage.getItem('token');
    this.httpheaders = new HttpHeaders({
      'Content-Type':  'application/json',
      'Authorization': this.str
  });
    return this.http.post('https://notifyme69.herokuapp.com/api/add_course/',data,{headers : this.httpheaders});
  }
  ChangePassword(data : any): Observable<any>{
    this.str='Token '+sessionStorage.getItem('token');
    this.httpheaders = new HttpHeaders({
      'Content-Type':  'application/json',
      'Authorization': this.str
  });
   return this.http.post('https://notifyme69.herokuapp.com/api/changepassword/',data,{headers:this.httpheaders});
  }
  SendNotif(data:any): Observable<any>{
    this.str='Token '+sessionStorage.getItem('token');
    this.httpheaders = new HttpHeaders({
      'Content-Type':  'application/json',
      'Authorization': this.str
  });
   return this.http.post('https://notifyme69.herokuapp.com/api/send_notif/',data,{headers:this.httpheaders});
  }
  getStudentAndTa(data:any): Observable<any>{
    this.str='Token '+sessionStorage.getItem('token');
    this.httpheaders = new HttpHeaders({
      'Content-Type':  'application/json',
      'Authorization': this.str
  });
  return this.http.post('https://notifyme69.herokuapp.com/api/getStudentsTas/',data,{headers:this.httpheaders});
  }
  addTA(data:any): Observable<any>{
    this.str='Token '+sessionStorage.getItem('token');
    this.httpheaders = new HttpHeaders({
      'Content-Type':  'application/json',
      'Authorization': this.str
  });
  return this.http.post('https://notifyme69.herokuapp.com/api/addTa/',data,{headers:this.httpheaders});
  }
  removeStudent(data:any): Observable<any>{
    this.str='Token '+sessionStorage.getItem('token');
    this.httpheaders = new HttpHeaders({
      'Content-Type':  'application/json',
      'Authorization': this.str
  });
  return this.http.post('https://notifyme69.herokuapp.com/api/removestudent/',data,{headers:this.httpheaders});
  }
  getNotif(data:any): Observable<any>{
    this.str='Token '+sessionStorage.getItem('token');
    this.httpheaders = new HttpHeaders({
      'Content-Type':  'application/json',
      'Authorization': this.str
  });
  return this.http.post('https://notifyme69.herokuapp.com/api/inst/get_notifs/',data,{headers:this.httpheaders});
  }
  getNotifDetails(data:any): Observable<any>{
    this.str='Token '+sessionStorage.getItem('token');
    this.httpheaders = new HttpHeaders({
      'Content-Type':  'application/json',
      'Authorization': this.str
  });
  return this.http.post('https://notifyme69.herokuapp.com/api/inst/get_notif_details/',data,{headers:this.httpheaders});
  }
  canActivate(): boolean{
    if(sessionStorage.getItem('state')=='true') return true;
    else return false;
  }
}