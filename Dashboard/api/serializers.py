from django.contrib.auth.models import User
from rest_framework import serializers
from rest_framework.validators import UniqueTogetherValidator
from core.models import user_type

class UserSerializer(serializers.ModelSerializer):

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        return user

    class Meta:
        model = User
        fields = (
            'username',
            'first_name',
            'last_name',
            'email',
            'password',
        )
        validators = [
            UniqueTogetherValidator(
                queryset=User.objects.all(),
                fields=['username', 'email']
            )
        ]
class registerSerializer(serializers.ModelSerializer):
    password2=serializers.CharField(style={'input_type':'password'},write_only=True)
    username=serializers.CharField(style={'input_type':'text'},write_only=True)
    email=serializers.CharField(style={'input_type':'text'},write_only=True)
    
    class Meta:
        model = User
        fields = ['email','username','password','password2']
        extra_kwargs = {
            'password': {'write_only':True}
        }
    def save(self):
        newuser = User(
                    username=self.validated_data['username'],
                    email=self.validated_data['email'],
        )
        password=self.validated_data['password']
        password2=self.validated_data['password2']

        if password!=password2:
            raise serializers.ValidationError({'password':'Password must match.'})
        newuser.set_password(password)
        newuser.save()
        newcustomuser = user_type(is_student=True,user=newuser,courses=[])
        newcustomuser.save()
        return newcustomuser