from django.db import models
from django.contrib.auth.models import User
# Create your models here.
class Notification(models.Model):
    Title_text = models.CharField(max_length=50)
    Content_text = models.CharField(max_length=300)
    
#class DashboardUsers(models.Model):


class Course(models.Model):
    instructors = models.ManyToManyField(User,related_name="instrictors")
    students = models.ManyToManyField(User,related_name="students")
    tas = models.ManyToManyField(User,related_name="Tas")
    code = models.CharField(User,max_length=6)

class user_type(models.Model):
    is_instructor = models.BooleanField(default=False)
    is_student = models.BooleanField(default=False)
    is_ta = models.BooleanField(default=False)
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    courses = models.ManyToManyField(Course)
    def __str__(self):
        if self.is_student == True:
            return User.get_username(self.user) + " - is_student"
        elif self.is_instructor :
            return User.get_username(self.user) + " - is_instructor"
