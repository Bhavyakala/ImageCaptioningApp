from django.shortcuts import render
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Inference
from .serializers import InferenceSerializer
import io
# Create your views here.

# @csrf_exempt
@api_view(['POST'])
def image_upload(request):

    if request.method =='POST':
        print(request.data)
        serializer = InferenceSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data,status=status.HTTP_201_CREATED)
        else :
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)


