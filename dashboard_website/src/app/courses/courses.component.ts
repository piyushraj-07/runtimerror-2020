import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { FormControl,FormGroup } from '@angular/forms';
import { AuthService } from '../auth.service';
@Component({
  selector: 'app-courses',
  templateUrl: './courses.component.html',
  styleUrls: ['./courses.component.scss']
})
export class CoursesComponent implements OnInit {
  listdisp=false;
  notifdisp=false;
  notifflg=true;
  taflg=false;
  removeflg=false;
  varta=false;
  Dict={'students':[],'tas':[]};
  flag2=false;
  flag1=false;
  notifs=[];
  constructor(private auth:AuthService,private router: Router) { }
  newstr="";
  empForm = new FormGroup({
    username: new FormControl(''),
    course: new FormControl(''),
    title: new FormControl(''),
    content: new FormControl(''),
    flag: new FormControl(''),
  });
  empForm1 = new FormGroup({
    username: new FormControl(''),
    course: new FormControl(''),
  });
  empForm2 = new FormGroup({
    username: new FormControl(''),
    course: new FormControl(''),
  });
  empForm3 = new FormGroup({
    username: new FormControl(''),
    course: new FormControl(''),
  });
  empForm4 = new FormGroup({
    username: new FormControl(''),
    course: new FormControl(''),
  });
  ngOnInit(): void {
    if(sessionStorage.getItem('TA')=='false') this.varta=false;
    else this.varta=true;
    this.newstr=this.router.url.replace(/%20/g," ");
    this.newstr=this.newstr.replace(/\//g,"");
    this.newstr=this.newstr.substring(4);
    sessionStorage.setItem('course',this.newstr);
    this.empForm.value.course=this.newstr;
    this.empForm.value.username=sessionStorage.getItem('username');
    this.auth.VerifyInst(this.empForm.value).subscribe(
      res => {
        console.log(res);
      },
      error => {
        console.log(error);
        this.router.navigateByUrl("/home");
      }
    )
  }
  async onSubmit(){
    this.empForm.value.course=this.newstr;
    this.empForm.value.username=sessionStorage.getItem('username');
    await this.auth.SendNotif(this.empForm.value);
    window.location.reload();
  }
  func(){
    this.listdisp=true;
    this.notifdisp=false;
    this.flag2=true;
    this.empForm1.value.username=sessionStorage.getItem('username');
    this.empForm1.value.course=this.newstr;
    this.auth.getStudentAndTa(this.empForm1.value).subscribe(
      res => {
        this.Dict=res;
        console.log(res);
      },
      error => {
        console.log(error);
      }
    )
  }
  onSubmit1(){
    this.empForm2.value.course=this.newstr;
    this.auth.addTA(this.empForm2.value).subscribe(
      res => {
        console.log(res);
        alert("Ta added");
      },
      error => {
        console.log(error);
        alert("Ta not registered");
      }
    )
  }
  onSubmit2(){
    this.empForm3.value.course=this.newstr;
    this.auth.removeStudent(this.empForm3.value).subscribe(
      res => {
        console.log(res);
        alert("Student removed successfully");
      },
      error => {
        console.log(error);
        alert("No such student");
      }
    )
  }
  funcnotif(){
    this.listdisp=false;
    this.notifdisp=true;
    this.flag1=true;
    this.empForm4.value.course=this.newstr;
    this.empForm4.value.username=sessionStorage.getItem('username');
    this.auth.getNotif(this.empForm4.value).subscribe(
      res => {
        this.notifs=res;
        console.log(res);
      },
      error => {
        console.log(error);
      }
    )
  }
  func1(){
    this.notifflg=!this.notifflg;
    this.removeflg=false;
    this.taflg=false;
  }
  func2(){
    this.notifflg=false;
    this.removeflg=false;
    this.taflg=!this.taflg;
  }
  func3(){
    this.notifflg=false;
    this.removeflg=!this.removeflg;
    this.taflg=false;
  }
}
