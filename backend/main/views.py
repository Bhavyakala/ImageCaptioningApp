from django.shortcuts import render
from django.conf import settings
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Inference
from .serializers import InferenceSerializer
import cv2
import numpy as np
import os
from .inference import run_inference


base_dir = settings.BASE_DIR

@api_view(['POST'])
def image_upload(request):

    if request.method =='POST':
        serializer = InferenceSerializer(data=request.data)
        if serializer.is_valid():
            image = request.FILES['image']
            image = cv2.imdecode(np.fromstring(image.read(), np.uint8), cv2.IMREAD_UNCHANGED)
            desc = run_inference(os.path.join(base_dir,"main/ml_models/model-ep001-loss3.278-val_loss3.739.h5"), 2, image)
            serializer.validated_data['description'] = desc
            print(serializer.validated_data)
            serializer.save()
            return Response(serializer.data,status=status.HTTP_201_CREATED)
        else :
            print(serializer.errors)
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)


