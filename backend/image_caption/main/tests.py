# from django.test import TestCase
from rest_framework import status
from rest_framework.test import APITestCase
from django.core.files.uploadedfile import InMemoryUploadedFile, SimpleUploadedFile
import os
from django.conf import settings
from PIL import Image

basedir = settings.BASE_DIR
# Create your tests here.

class InferenceUploadTest(APITestCase):

  def test_file_is_accepted(self):

    """
      Test for file uploads
    """
    # print(basedir)
    file = open(os.path.join(basedir,'main/testImages/test1.jpeg') , 'rb')
    f = SimpleUploadedFile("D:/Github/ImageCaptioningApp/backend/image_caption/main/testImages/test1.jpeg",file.read(),content_type='image/jpeg')
    response = self.client.post('http://127.0.0.1:8000/image_upload/',data={'image':f},format='multipart')
    # print(response.content)
    self.assertEqual(response.status_code, status.HTTP_201_CREATED)