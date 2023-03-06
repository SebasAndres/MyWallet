from django.urls import path
from API import views

urlpatterns = [
    path("", views.init_view),
    path("home", views.init_view),
    path("login/<user>/<psw>", views.log_in), # autenticacion
    path("home/<user_key>", views.home_view_data), # datos de inicio
    path("add_money/<user>/<psw>/<acc>/<value>/<det>/<cat>", views.add_money_1c), # ingreso en un pago
    path("add_money/<user>/<psw>/<acc>/<value>/<det>/<cat>/<cuotes>/<interest>", views.add_money), # ingreso en cuotas
    path("spend_money/<user>/<psw>/<acc>/<value>/<det>/<cat>", views.spend_money_1c), # gasto en un pago
    path("spend_money/<user>/<psw>/<acc>/<value>/<det>/<cat>/<cuotes>/<interest>", views.spend_money), # gasto en cuotas
    path("account/<user_key>/<acc>", views.get_account), # ver estado de la cuennta
    path("view_ops/<user_key>/<psw>", views.view_ops), # ver operaciones 
    path("register", views.register_user)
]
