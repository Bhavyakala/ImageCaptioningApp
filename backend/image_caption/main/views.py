from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.parsers import JSONParser
from rest_framework.decorators import api_view
from .models import Inference
from .serializers import InferenceSerializer
import io
# Create your views here.

# @csrf_exempt
@api_view(['POST'])
def image_upload(request):

    if request.method =='POST':
        # model = Inference(request.POST)
        # print(model.image)
        print(request.data)
        # model.save()
        serializer = InferenceSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data,status=200)
        else :
            return JsonResponse(serializer.errors,status=401)


