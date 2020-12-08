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
  flag69=false;
  flag70=false;
  courses=[];
  empForm = new FormGroup({
    username: new FormControl(''),
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
    this.auth.CoursesList({'username': sessionStorage.getItem('username'),'fcmtoken':''}).subscribe(
      res => {
        this.courses=res;
        console.log(res);
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
      },
      error => {
        console.log(error);
      }
    )
  }
  onSubmit1(){
    this.auth.ChangePassword(this.empForm1.value).subscribe(
      res => {
        console.log(res);
        if(res.response=="fail") alert("Unsuccessfull");
        else alert("password changed successfully");
      },
      error => {
        console.log(error);
         alert("Unsuccessfull");
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
