from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from API.scripts.firestore import LoginAuth, home_view, move_money, \
                                  read_account, register_new_user
from API.models import OPS, User
import datetime
# Create your views here.

def init_view (request):
    return render(request, "read_me.html")

def log_in (request, user, psw):
    resp = LoginAuth(user, psw)
    return JsonResponse(resp)

def home_view_data (request, user_key):
    resp = home_view (user_key)
    return JsonResponse(resp)

def add_money_1c (request, user, psw, acc, value, det, cat):
    # solo para ingreso unico
    ops = OPS (cat, acc, det, datetime.datetime.now(), value)
    resp = move_money(user, psw, ops)
    return JsonResponse(resp)

def spend_money_1c (request, user, psw, acc, value, det, cat):
    # solo para pago unico
    ops = OPS (cat, acc, det, datetime.datetime.now(), -float(value))
    resp = move_money(user, psw, ops)
    return JsonResponse(resp)

def add_money (request, user, psw, acc, value, det, cat, cuotes, interest):
    # cuando hay mas de una cuota en el ingreso
    ops = OPS (cat, acc, det, datetime.datetime.now(), value)
    ops.set_cuotes_interest(cuotes, interest)
    resp = move_money(user, psw, ops)
    return JsonResponse(resp)

def spend_money (request, user, psw, acc, value, det, cat, cuotes, interest):
    # cuando hay mas de una cuota en el ingreso
    ops = OPS (cat, acc, det, datetime.datetime.now(), -float(value))
    ops.set_cuotes_interest(cuotes, interest)
    resp = move_money(user, psw, ops)
    return JsonResponse(resp)

def get_account (request, user_key, acc):
    acc_data = read_account(user_key, acc)
    return JsonResponse(acc_data)

def view_ops (request, user_key, psw):
    user_ops = {} # read_ops_from_user(user_key, psw)
    return JsonResponse(user_ops)

def register_user (request):
    if request.method == "POST":
        print (request.POST)
        new_user = User (request.POST)
        resp = register_new_user(new_user)
        return JsonResponse(resp)
    else:
        return JsonResponse({})