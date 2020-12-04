from django.shortcuts import render

# Create your views here.
from .serializers import UserSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAdminUser
from django.contrib.auth.models import User
from rest_framework.decorators import api_view
from django.contrib.auth import authenticate, login
from core.models import user_type
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
        username=request.POST.get('username')
        password=request.POST.get('password')
        user = authenticate(request,username=username,password=password)
        data = {}
        print("gg")
        print(user)
        if user is not None and user_type.objects.get(user=user).is_instructor:
            #account = serializer.save()
            data['response']="Success"
        else:
            data['response']="Fail" 
        return Response(data)