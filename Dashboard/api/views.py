import json
from django.shortcuts import render

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
from core.models import Course, Student , Instructor, Notification
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
        return Response(l)\

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
        print(coursename)
        course = Course.objects.get(name=coursename)
        notifs = list(Notification.objects.filter(course=course))
        data = {}
        l=[]
        for i in notifs :
            l.append(i.Title_text)
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
        notif_id = int(body['id'])
        print(coursename,notif_id)
        course = Course.objects.get(name=coursename)
        print(course)
        notifs = list(Notification.objects.filter(course=course))
        print(notifs)
        reqnotif = notifs[notif_id]
        data = {}
        data['content']=reqnotif.Content_text
        data['time']=reqnotif.created_at
        data['sender']=reqnotif.Sentby.username
        data['title']=reqnotif.Title_text
        return Response(data)
        
