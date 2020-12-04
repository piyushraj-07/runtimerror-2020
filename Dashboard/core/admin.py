from django.contrib import admin
from .models import Notification,user_type,Course
# Register your models here.
admin.site.register(Notification)
admin.site.register(user_type)
admin.site.register(Course)