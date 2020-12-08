import { Component, OnInit } from '@angular/core';
import { FormControl,FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../auth.service';
@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
  providers: [AuthService]
})
export class LoginComponent implements OnInit {
  myurl='/home';
  constructor(private auth:AuthService,private router: Router) { }

  empForm = new FormGroup({
    username: new FormControl(''),
    password: new FormControl(''),
  });
  
  onSubmit(){
    console.log(this.empForm.value);
    this.auth.LoginUser(this.empForm.value).subscribe(
      res => {
        console.log(res);
        sessionStorage.setItem('state','true');
        sessionStorage.setItem('token',res.token);
        sessionStorage.setItem('username',this.empForm.value.username);
        alert("Welcome Student");
        this.router.navigateByUrl(this.myurl);
      },
      error => {
        alert('Not Registered');
      }
    );
    }
  ngOnInit(): void {
  }
}
