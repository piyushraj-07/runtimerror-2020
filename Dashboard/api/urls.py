from django.urls import path
from .views import *
app_name = 'api'
urlpatterns = [
    path('user/', UserRecordView.as_view(), name='users'),
    path('register/app/',regist_view,name='register'),
    path('login/dashboard/',login_dashboard,name='login'),
    path('login/app/',login_app,name='login'),
    path('get_courses/',CourseViewStudents.as_view(),name="courses"),
    path('join_course/',joinCourseView.as_view(),name="joincourses"),
    path('get_notifs/',NotifViewStudents.as_view(),name="joincourses"),
    path('inst/get_notifs/',NotifViewInst.as_view(),name="joincourses"),    
    path('inst/get_courses/', CourseViewInstructors.as_view(),name="get_inst_courses"),
    path('add_course/',AddCourse.as_view(),name="addCourses"),
    path('get_notif_details/',getNotifDetails.as_view(),name="get_notif_details"),
    path('inst/get_notif_details/',getNotifDetailsInst.as_view(),name="get_notif_details"),
    path('send_notif/',sendNotif.as_view(),name="notifications"),
    path('getStudentsTas/',getStudentsAndTAs.as_view(),name="getall"),
    path('getStudents/',getStudents.as_view(),name="getall"),
    path('getTas/',getTAs.as_view(),name="getall"),
    path('addTa/',AddTa.as_view(),name="addTa"),
    path('removestudent/',RemoveStudent.as_view(),name="removestud"),
    path('changepassword/',changePassword.as_view(),name="changepassword"),
    path('logout/',Logout.as_view(),name="logout")
]