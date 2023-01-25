import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use a service account.
cred = credentials.Certificate('API/scripts/firestore_key.json')
app = firebase_admin.initialize_app(cred)
db = firestore.client()

LogInReference = db.collection(u"Log In")
MPU_Reference = db.collection(u"MovimientosPorUsuario")

def LoginAuth (user, psw):    
    docs = LogInReference.stream()
    for doc in docs:
        usr_data_i = doc.to_dict()
        if usr_data_i["User"] == user and usr_data_i["Psw"] == psw:
            return { "status": 200, "auth": True, "user_key": doc.id }
    return { "status": 200, "auth": False }

def home_view (user_key):
    user_coll = MPU_Reference.document(user_key)

    # Read user data for home page
    name = LogInReference.document(user_key).get().to_dict()["User"]
    pie_chart_categories = user_coll.collection(u"MisDatos").document(u"Categorias").get().to_dict()
    user_accounts = list ()
    for acc in user_coll.collection(u"Cuentas").stream():
        user_accounts.append(acc.id)

    return {
        "name": name,
        "pie_chart": pie_chart_categories,
        "cuentas": user_accounts
    }