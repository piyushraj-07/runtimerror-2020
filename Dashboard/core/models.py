from django.db import models
from django.contrib.auth.models import User
# Create your models here.

#class DashboardUsers(models.Model):


class Course(models.Model):
    instructors = models.ManyToManyField(User,related_name="instructors")
    students = models.ManyToManyField(User,related_name="students")
    tas = models.ManyToManyField(User,related_name="Tas")
    code = models.CharField(max_length=6,unique=True)
    name = models.CharField(max_length=50,default='',unique=True)
    def __str__(self):
        return self.name

class Notification(models.Model):
    Title_text = models.CharField(max_length=50)
    Content_text = models.CharField(max_length=300)
    Sentby = models.ForeignKey(User,default=1,on_delete=models.CASCADE,related_name="sender")
    course = models.ForeignKey(Course,default=1,on_delete=models.CASCADE, related_name="course")
    ReadBy = models.ManyToManyField(User,default=[1],related_name="readby")
    created_at = models.DateTimeField(auto_now_add=True)
    priority = models.BooleanField(default=False)

class Student(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    courses = models.ManyToManyField(Course)
    token = models.CharField(max_length=100)
    def __str__(self):
            return User.get_username(self.user) + " - is_student"
       

class Instructor(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    courses = models.ManyToManyField(Course)
    is_ta = models.BooleanField(default=False)
    def __str__(self):
        return User.get_username(self.user) + " - is_instructor"

class OTP(models.Model):
    email = models.EmailField(max_length=255)
    OTP = models.CharField(max_length=6)
    Date = models.DateTimeField(auto_now=True)