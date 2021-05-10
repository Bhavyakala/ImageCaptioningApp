from django import  forms

class UploadForm(forms.Form) :
    picture = forms.ImageField()