from django.test import TestCase
import datetime 
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from dateutil.relativedelta import relativedelta
from models import OPS, ToPay

# Use a service account.
cred = credentials.Certificate('scripts/firestore_key.json')
app = firebase_admin.initialize_app(cred)
db = firestore.client()

LogInReference = db.collection(u"Log In")
MPU_Reference = db.collection(u"MovimientosPorUsuario")

