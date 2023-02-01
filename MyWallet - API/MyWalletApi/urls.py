from django.urls import path
from API import views

urlpatterns = [
    path("", views.init_view),
    path("logIn/<user>/<psw>", views.log_in),
    path("home/<user_key>", views.home_view_data),
    path("add_money/<user>/<psw>/<acc>/<value>/<det>/<cat>", views.add_money_1c),
    path("add_money/<user>/<psw>/<acc>/<value>/<det>/<cat>/<cuotes>/<interest>", views.add_money),
    path("spend_money/<user>/<psw>/<acc>/<value>/<det>/<cat>", views.spend_money_1c),
    path("spend_money/<user>/<psw>/<acc>/<value>/<det>/<cat>/<cuotes>/<interest>", views.spend_money),
    path("account/<user_key>/<acc>", views.get_account)
]
