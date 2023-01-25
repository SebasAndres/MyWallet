from django.http import JsonResponse, HttpResponse
from API.scripts.firestore import LoginAuth, home_view

# Create your views here.

def init_view (request):
    return HttpResponse("<h1>Bienvenido a la API de MyWallet</h1>")

def log_in (request, user, psw):
    resp = LoginAuth(user, psw)
    return JsonResponse(resp)

def home_view_data (request, user_key):
    resp = home_view (user_key)
    return JsonResponse(resp)