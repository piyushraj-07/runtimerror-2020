from django.urls import path
from .views import UserRecordView , regist_view

app_name = 'api'
urlpatterns = [
    path('user/', UserRecordView.as_view(), name='users'),
    path('register-user/',regist_view,name='register')
]