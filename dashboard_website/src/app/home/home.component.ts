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
  courses=[{title : "cs 213"},{title: "cs 215"}];
  empForm = new FormGroup({
    username: new FormControl(''),
    course: new FormControl(''),
    code: new FormControl(''),
  });
  myurl1="/login";
  myurl='/courses';
  constructor(private auth:AuthService,private router: Router) { }

  ngOnInit(): void {
     if(sessionStorage.getItem('TA')=='false') this.flag1=false;
     else this.flag1=true;
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
  func1(){
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
  func2(){
    sessionStorage.setItem('state','false');
    this.router.navigateByUrl('/');
  }
}
