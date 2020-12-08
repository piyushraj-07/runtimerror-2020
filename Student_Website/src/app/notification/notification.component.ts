import { Component, OnInit } from '@angular/core';
import { AuthService } from '../auth.service';
import { FormControl,FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
@Component({
  selector: 'app-notification',
  templateUrl: './notification.component.html',
  styleUrls: ['./notification.component.scss']
})
export class NotificationComponent implements OnInit {
  newstr="";
  Dict={'content':"",'title':"",'sender':"",'time':"",'read':[] };
  constructor(private auth:AuthService,private router: Router) { }
  empForm = new FormGroup({
    course: new FormControl(''),
    name: new FormControl(''),
  });
  ngOnInit(): void {
    this.newstr=this.router.url.replace(/%20/g," ");
    this.newstr=this.newstr.replace(/\//g,"");
    this.newstr=this.newstr.substring(12);
    this.empForm.value.course=sessionStorage.getItem('course');
    this.empForm.value.name=this.newstr;
    this.auth.getNotifDetails(this.empForm.value).subscribe(
      res => {
        this.Dict=res;
        console.log(res);
      },
      error => {
        this.router.navigateByUrl('/');
        console.log(error);
      }
    )
  }

}
