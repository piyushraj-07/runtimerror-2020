from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse
from django.shortcuts import render
from .forms import NotificationForm
from pyfcm import FCMNotification

def index(request):
    return render(request,'core/index.html')

def createNotif(request):
    form = NotificationForm(request.POST or None)
    if form.is_valid():
        form.save()
        Title=form.cleaned_data['Title_text']
        Msg=form.cleaned_data['Content_text']
        dat={}
        sendNotif(Title,Msg,dat)
        print("sent")
    context = {
        'form'  : form
    }
    return render(request,"core/CreateNotif.html",context)

def sendNotif(title, message, data):
    FCM_SERVER_KEY="AAAAgzHL4tY:APA91bHuZKqD66nhGAhW647HIlnNcmTcWF0GMa4ymFd_SHAqLDdQZaOMgdkBvh6YgD5BknyvcQoNcpDaf7N8NpmCjpTicDzMousJYI-Vms8aa4ceikbp4YflPP4T08bKeiWdronkt6Bj"

    push_service = FCMNotification(api_key=FCM_SERVER_KEY)
    fcm_token = ["e7Oq97BYQT-uEyLcdwex7v:APA91bE6k8nBJlcdDYNVAb2eq3CXptHJ4f2ZJWEzHoaA0-XNLeVA0VEPd0_hZb6gU30hTsPc4tCEzCK3-1-EOrB_Gc1NSBlEmP2WIL3Ngh3k1EirpmIUKZ6SOSoQbFNnwd6_sChAm3KS"]
    print("success")
    return push_service.notify_multiple_devices(
          registration_ids=fcm_token,message_title=title,
          message_body=message, data_message=data)

