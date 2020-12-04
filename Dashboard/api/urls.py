from django.urls import path
from .views import UserRecordView , regist_view ,login_dashboard

app_name = 'api'
urlpatterns = [
    path('user/', UserRecordView.as_view(), name='users'),
    path('register-user/',regist_view,name='register'),
    path('login/dashboard',login_dashboard,name='login'),
]