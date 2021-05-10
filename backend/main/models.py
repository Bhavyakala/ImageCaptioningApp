from django.db import models
from django.db.models.signals import post_delete
from django.dispatch import receiver
import os
# Create your models here.

class Inference(models.Model):
    image = models.ImageField(upload_to='images/')
    description = models.CharField(max_length=200,null=True,default=None)

def _delete_file(path):
   """ Deletes file from filesystem. """
   if os.path.isfile(path):
       os.remove(path)

@receiver(post_delete, sender=Inference)
def delete_file(sender, instance, *args, **kwargs):
    """ Deletes image files on `post_delete` """
    if instance.image:
        _delete_file(instance.image.path)