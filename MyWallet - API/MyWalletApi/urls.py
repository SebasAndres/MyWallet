from django.urls import path
from API import views

urlpatterns = [
    path("", views.init_view),
    path("logIn/<user>/<psw>", views.log_in),
    path("home/<user_key>", views.home_view_data)
]
