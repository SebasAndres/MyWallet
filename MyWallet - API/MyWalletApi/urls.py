from django.urls import path
from API import views

urlpatterns = [
    path("logIn/<user>/<psw>", views.log_in),
]
