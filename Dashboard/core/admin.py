from django.contrib import admin
from .models import Notification,Student,Instructor,Course
# Register your models here.
admin.site.register(Notification)
admin.site.register(Student)
admin.site.register(Instructor)
admin.site.register(Course)