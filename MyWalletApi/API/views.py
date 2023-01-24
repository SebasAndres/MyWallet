from django.http import JsonResponse
from API.firestore import LoginAuth

# Create your views here.
def log_in (request, user, psw):
    resp = LoginAuth(user, psw)
    return JsonResponse(resp)

def home_view_data (request, user_key):
    return JsonResponse({"a": "b"})