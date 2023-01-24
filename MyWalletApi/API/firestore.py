import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use a service account.
cred = credentials.Certificate('API/firestore_key.json')
app = firebase_admin.initialize_app(cred)
db = firestore.client()

LogInReference = db.collection(u"Log In")

def LoginAuth (user, psw):    
    docs = LogInReference.stream()
    for doc in docs:
        usr_data_i = doc.to_dict()
        if usr_data_i["User"] == user and usr_data_i["Psw"] == psw:
            return { "status": 200, "auth": True, "user_key": doc.id }
    return { "status": 200, "auth": False }
