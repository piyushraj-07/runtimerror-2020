import json
from django.shortcuts import render
import datetime
import time
# Create your views here.
from .serializers import UserSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAdminUser, IsAuthenticated
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view
from django.contrib.auth import authenticate, login
from core.models import Course, Student , Instructor, Notification, OTP
from pyfcm import FCMNotification
import random
from django.core.mail import send_mail


class UserRecordView(APIView):
    """
    API View to create or get a list of all the registered
    users. GET request returns the registered users whereas
    a POST request allows to create a new user.
    """
    permission_classes = [IsAdminUser]

    def get(self, format=None):
        users = User.objects.all()
        serializer = UserSerializer(users, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid(raise_exception=ValueError):
            serializer.create(validated_data=request.data)
            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            {
                "error": True,
                "error_msg": serializer.error_messages,
            },
            status=status.HTTP_400_BAD_REQUEST
        )
from api.serializers import registerSerializer

@api_view(['POST',])
def regist_view(request):
    print("yus")
    if request.method == 'POST':
        serializer = registerSerializer(data=request.data)
        data = {}
        print("gg")
        if serializer.is_valid():
            account = serializer.save()
            data['response']="Success"
        else:
            data = serializer.error
        return Response(data)
@api_view(['POST',])
def login_dashboard(request):
    print("yus")
    if request.method == 'POST':
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        username = body['username']
        password = body['password']
        print(username,password)
        user = authenticate(username=username,password=password)
        
        data = {}
        print("gg")
        print(user)
        if user is not None:
            instructor = Instructor.objects.get(user=user)
            if instructor is not None:
                token, created = Token.objects.get_or_create(user=user)
            #account = serializer.save()
                data['response']="Success"
                data['token']=token.key
                data['isTa']=instructor.is_ta
            else :
                data['response']="Fail"
        else:
            data['response']="Fail" 
        return Response(data)

@api_view(['POST',])
def login_app(request):
    print("yus")
    if request.method == 'POST':
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        username = body['username']
        password = body['password']
        print(username,password)
        user = authenticate(username=username,password=password)
        data = {}
        print("gg")
        print(user)
        if user is not None :
            studen = Student.objects.get(user=user)
            if studen is not None :
                token, created = Token.objects.get_or_create(user=user)
            #account = serializer.save()
                data['token']=token.key
                return Response(data)
            else :
                return Response(status=401)
        else:
             return Response(status=401)
        return Response(data)

class CourseViewStudents(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request,format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        username = body['username']
        fcmtoken = body['fcmtoken']
        user = User.objects.get(username=username)
        data = {}
        student = Student.objects.get(user=user)
        student.token = fcmtoken
        student.save()
        print(fcmtoken)
        l=[]
        for i in student.courses.all() :
            l.append(i.name)
        data['courses']=l
        return Response(l)

class CourseViewInstructors(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request,format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        username = body['username']
        user = User.objects.get(username=username)
        data = {}
        instruct = Instructor.objects.get(user=user)
        l=[]
        for i in instruct.courses.all() :
            l.append(i.name)
        data['courses']=l
        return Response(l)

class joinCourseView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request,format=None) :
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        username = body['username']
        code = body['code']
        user = User.objects.get(username=username)
        data = {}
        student = Student.objects.get(user=user)
        course = Course.objects.get(code=code)
        print(course,student,user,code)
        if course is not None :
            student.courses.add(course)
            course.students.add(user)
            data["response"]="success"
        else :
            data["response"]="fail"
        return Response(data)  

class NotifViewStudents(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request,format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        coursename = body['course']
        username = body['username']
        print(coursename, username)
        course = Course.objects.get(name=coursename)
        notifs = list(Notification.objects.filter(course=course))
        data = {}
        l=[]
        k=[]
        g=[]
        for i in notifs[::-1] :
            l.append(i.Title_text)
            k.append(i.priority)
            try :
                user = i.ReadBy.get(username=username)
                print(user)
                g.append(True)
            except:
                g.append(False)
        print("gg")
        data['titles']=l
        data['priority']=k
        data['seen']=g
        return Response(data)      

class NotifViewStudentsWeb(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request,format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        coursename = body['course']
        username = body['username']
        print(coursename, username)
        course = Course.objects.get(name=coursename)
        notifs = list(Notification.objects.filter(course=course))
        data = {}
        l=[]
        k=[]
        g=[]
        ind = 0
        for i in notifs[::-1] :
            l.append(str(ind+1)+ " " + i.Title_text)
            ind+=1
            k.append(i.priority)
            try :
                user = i.ReadBy.get(username=username)
                print(user)
                g.append(True)
            except:
                g.append(False)
        print("gg")
        data['titles']=l
        data['priority']=k
        data['seen']=g
        return Response(data)      
class NotifViewInst(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request,format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        coursename = body['course']
        print(coursename)
        course = Course.objects.get(name=coursename)
        notifs = list(Notification.objects.filter(course=course))
        data = {}
        l=[]
        ind=0
        for i in notifs[::-1] :
            l.append(str(ind+1)+" "+i.Title_text)
            ind+=1
        data['courses']=l
        return Response(l)    

class AddCourse(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        coursename = body['course']
        username = body['username']
        code = body['code']
        data={}
    
        user = User.objects.get(username=username)
        inst = Instructor.objects.get(user=user)
        newcourse = Course.objects.create(code=code,name=coursename)
        newcourse.instructors.add(user)
        print(newcourse,inst,user)
        newcourse.save()
        inst.courses.add(newcourse)
        data["response"]="Success"
        return Response(data)


class getNotifDetails(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        coursename = body['course']
        username = body['username']
        user = User.objects.get(username=username)
        notif_id = int(body['id'])
        print(coursename,notif_id)
        course = Course.objects.get(name=coursename)
        print(course)
        notifs = list(Notification.objects.filter(course=course))
        print(notifs)
        notifs = notifs[::-1]
        reqnotif = notifs[notif_id]
        reqnotif.ReadBy.add(user)
        reqnotif.save()
        data = {}
        data['content']=reqnotif.Content_text
        data['time']=reqnotif.created_at
        data['sender']=reqnotif.Sentby.username
        data['title']=reqnotif.Title_text
        return Response(data)


class Logout(APIView):
    permission_classes = [IsAuthenticated]
    def post(self,request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        username=body['username']
        user = User.objects.get(username=username)
        student = Student.objects.get(user=user)
        student.token=''
        student.save()
        return Response("Success")

class getNotifDetailsInst(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        coursename = body['course']
        notif_id = list(body['name'].split())
        notif_id=int(notif_id[0])
        notif_id-=1
        print(coursename,notif_id)
        course = Course.objects.get(name=coursename)
        print(course)
        notifs = list(Notification.objects.filter(course=course))
        notifs = notifs[::-1]
        print(notifs)
        reqnotif = notifs[notif_id]
        data = {}
        data['content']=reqnotif.Content_text
        data['time']=reqnotif.created_at
        data['sender']=reqnotif.Sentby.username
        data['title']=reqnotif.Title_text
        l=[]
        for i in reqnotif.ReadBy.all():
            l.append(i.username)
        data["read"]=l
        return Response(data)

class getNotifDetailsStudentsWeb(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        coursename = body['course']
        notif_id = list(body['name'].split())
        username = body['username']
        user = User.objects.get(username=username)
        notif_id=int(notif_id[0])
        notif_id-=1
        print(coursename,notif_id)
        course = Course.objects.get(name=coursename)
        print(course)
        notifs = list(Notification.objects.filter(course=course))
        notifs=notifs[::-1]
        print(notifs)
        reqnotif = notifs[notif_id]
        data = {}
        if user in reqnotif.ReadBy.all():
            data['seen']=True
        else :
            data['seen']=False
            reqnotif.ReadBy.add(user)
            reqnotif.save()
        
        data['content']=reqnotif.Content_text
        data['time']=reqnotif.created_at
        data['sender']=reqnotif.Sentby.username
        data['title']=reqnotif.Title_text
        data['priority']=reqnotif.priority
        
        return Response(data)
class sendNotif(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request , format=None ):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        coursename = body['course']
        username = body['username']
        title = body['title']
        content = body['content']
        prio = body['flag']
        if(prio=="Hard"):
            f=True
        else :
            f=False
        user = User.objects.get(username=username)
        course = Course.objects.get(name=coursename)
        notif = Notification.objects.create(Title_text=title,Content_text=content,Sentby=user,course=course,priority=f)
        notif.save()
        FCM_SERVER_KEY="AAAAgzHL4tY:APA91bHuZKqD66nhGAhW647HIlnNcmTcWF0GMa4ymFd_SHAqLDdQZaOMgdkBvh6YgD5BknyvcQoNcpDaf7N8NpmCjpTicDzMousJYI-Vms8aa4ceikbp4YflPP4T08bKeiWdronkt6Bj"
        push_service = FCMNotification(api_key=FCM_SERVER_KEY)
        data={}
        data['value']=notif.priority
        if(notif.priority):
            n=10
            while (True) :
                fcm_token=[]
                for i in Student.objects.filter(courses=course):
                    if i.user in notif.ReadBy.all():
                        continue
                    print(i,course)
                    fcm_token.append(i.token)
                if (len(fcm_token)==0):
                    break
                extra_notification_kwargs = {
                    'image':  "https://miro.medium.com/max/2710/1*VYhexO08Zwwg9Woa_VLeSA.jpeg"
                }
                push_service.notify_multiple_devices(
                    registration_ids=fcm_token,message_title=title,
                    message_body=content, data_message=data,extra_notification_kwargs=extra_notification_kwargs)
                n-=1
                time.sleep(10)
        else :
            fcm_token=[]
            for i in Student.objects.filter(courses=course):
                print(i,course)
                fcm_token.append(i.token)
            extra_notification_kwargs = {
            'sound':None
            }
            push_service.notify_multiple_devices(
                registration_ids=fcm_token,message_title=title,
                message_body=content, data_message=data,extra_notification_kwargs=extra_notification_kwargs,low_priority=True)
        return Response("Success")

class getStudentsAndTAs(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        coursename = body['course']
        course = Course.objects.get(name=coursename)
        data={}
        l=[]
        for i in Student.objects.filter(courses=course):
            l.append(i.user.username)
        data['students']=l
        l=[]
        for i in Instructor.objects.filter(courses=course):
            if(i.is_ta):
                l.append(i.user.username)
        data['tas']=l
        return Response(data)

class getTAs(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        coursename = body['course']
        course = Course.objects.get(name=coursename)
        data={}
        l=[]

        for i in Instructor.objects.filter(courses=course):
            if(i.is_ta):
                l.append(i.user.username)
        data['tas']=l
        return Response(l)

class getStudents(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        coursename = body['course']
        course = Course.objects.get(name=coursename)
        data={}
        l=[]
        for i in Student.objects.filter(courses=course):
            l.append(i.user.username)
        data['students']=l

        return Response(l)


class AddTa(APIView):
    permission_classes= [IsAuthenticated]
    def post( self, request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        coursename = body['course']
        ta=body['username']
        user = User.objects.get(username=ta)
        inst = Instructor.objects.get(user=user)
        if inst.is_ta:
            course=Course.objects.get(name=coursename)
            course.tas.add(user)
            inst.courses.add(course)
            course.save()
            inst.save()
            return Response("Success")
        else :
            return Response("Fail")

class RemoveStudent(APIView):
    permission_classes= [IsAuthenticated]
    def post( self, request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        print("yus")
        coursename = body['course']
        username=body['username']
        print(username)
        user = User.objects.get(username=username)
        stud = Student.objects.get(user=user)
        print(stud,user)
        course=Course.objects.get(name=coursename)
        course.students.remove(user)
        stud.courses.remove(course)
        course.save()
        stud.save()
        return Response("Success")

class changePassword(APIView):
    permission_classes = [IsAuthenticated]
    def post( self,request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        username = body['username']
        oldpassword = body['oldpassword']
        newpassword = body['newpassword']
        user = authenticate(username=username,password=oldpassword)
        data={}
        if user is not None:
            user.set_password(newpassword)
            user.save()
            token, created = Token.objects.get_or_create(user=user)
            #account = serializer.save()
            data['token']=token.key    
        else:
            data['response']="Fail"
        return Response(data)

class SendOTP(APIView):
    def post( self,request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        username = body['username']
        user = User.objects.get(username=username)
        email = body['email']
        otp = ''.join([str(random.randint(0, 999)).zfill(3) for _ in range(2)])
        newotp = OTP(OTP=otp,email=email)
        newotp.save()
        send_mail('OTP for reseting password',"Your otp is " + otp , 'notiflyer69@gmail.com',[email],fail_silently=False)
        return Response("Success")

class ConfirmOTP(APIView):
    def post(self, request, format=None):
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        otp = body['otp']
        email = body['email']
        username = body['username']
        otpobj = OTP.objects.get(OTP=otp)
        print("gg1")
       # if datetime.datetime.now()>otpobj.Date + datetime.timedelta(days=0,hours=1):
        #    return Response("Fail")
        print("gg2")
        if otpobj.email == email :
            password1=body['password1']
            password2=body['password2']
            print("gg3")
            if password1 == password2 :
                user = User.objects.get(username=username)
                user.set_password(password1)
                user.save()
                return Response("Success")
            else :
                return Response("Fail")
        else :
            return Response("Fail")        
