import { Component, OnInit } from '@angular/core';
import { AuthService } from '../auth.service';
import { FormControl,FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  flag=false;
  flag1=false;
  flag69=false;
  flag70=false;
  courses=[{title : "cs 213"},{title: "cs 215"}];
  empForm = new FormGroup({
    username: new FormControl(''),
    course: new FormControl(''),
    code: new FormControl(''),
  });
  empForm1 = new FormGroup({
    username: new FormControl(''),
    oldpassword: new FormControl(''),
    newpassword: new FormControl(''),
  });
  myurl1="/login";
  myurl='/courses';
  constructor(private auth:AuthService,private router: Router) { }

  ngOnInit(): void {
     if(sessionStorage.getItem('TA')=='false') this.flag1=false;
     else this.flag1=true;
     this.flag=true;
    this.auth.CoursesList({'username': sessionStorage.getItem('username')}).subscribe(
      res => {
        this.courses=res;
      },
      error => {
        console.log(error);
      }
    )
  }
  onSubmit(){
    this.empForm.value.username=sessionStorage.getItem('username');
    this.auth.addCourse(this.empForm.value).subscribe(
      res => {
        console.log(res);
        sessionStorage.setItem('temp','abc');
      },
      error => {
        console.log(error);
        sessionStorage.setItem('temp','abc');
      }
    )
    if(sessionStorage.getItem('temp')=='abc') window.location.reload();
  }
  onSubmit1(){
    this.auth.ChangePassword(this.empForm1.value).subscribe(
      res => {
        console.log(res);
      },
      error => {
        console.log(error);
      }
    )
  }
  func1(){
    this.flag69=!this.flag69;
    this.flag70=false;
  }
  func2(){
    sessionStorage.setItem('state','false');
    this.router.navigateByUrl('/');
  }
  func3(){
    this.flag70=!this.flag70;
    this.flag69=false;
  }
}
