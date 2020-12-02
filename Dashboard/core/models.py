from django.db import models

# Create your models here.
class Notification(models.Model):
    Title_text = models.CharField(max_length=50)
    Content_text = models.CharField(max_length=300)
    
#class DashboardUsers(models.Model):

    