import { Component, OnInit } from '@angular/core';
import { Form, FormControl,FormGroup } from '@angular/forms';
import { AuthService } from '../auth.service';
import { Router } from '@angular/router';
@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss']
})
export class SignupComponent implements OnInit {

  constructor(private auth:AuthService,private router: Router) { }

  empForm = new FormGroup({
    email: new FormControl(''),
    username: new FormControl(''),
    password: new FormControl(''),
    password2: new FormControl(''),
  });
  onSubmit(){
    this.auth.RegisterUser(this.empForm.value).subscribe(
      res => {
        console.log(res);
        alert("Registration Successfull");
        this.router.navigateByUrl("/login");
      },
      error => {
        alert("Registration Unsuccessfull");
      }
    )
  }
  ngOnInit(): void {
  }

}
