from django.db import models

# Create your models here.
class Notification(models.Model):
    Title_text = models.CharField(max_length=50)
    Content_text = models.CharField(max_length=300)
    
#class DashboardUsers(models.Model):

class AppUsers(models.Model):
    username = models.CharField(max_length=50)
    email = models.CharField(max_length=50)
    password = models.CharField(max_length=50)
    token = models.CharField(max_length=300)   
    def set_password(self,_password):
        self.password=_password