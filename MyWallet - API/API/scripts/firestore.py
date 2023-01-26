import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from dateutil.relativedelta import relativedelta

from API.models import OPS, ToPay
import datetime

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
            return { "status": "Ok", "auth": True, "user_key": doc.id }
    return { "status": "OK", "auth": False }

def home_view (user_key):
    user_coll = MPU_Reference.document(user_key)

    # Read user data for home page
    user_data_log = LogInReference.document(user_key).get().to_dict()
    name = user_data_log["User"]
    pic_url = user_data_log["Pic"]
    pie_chart_categories = user_coll.collection(u"MisDatos").document(u"Categorias").get().to_dict()
    user_accounts = list ()
    for acc in user_coll.collection(u"Cuentas").stream():
        user_accounts.append(acc.id)

    return {
        "nombre": name,
        "pie_chart": pie_chart_categories,
        "cuentas": user_accounts,
        "foto": pic_url
    }


def discount_from_account (user_key, acc, value):
    acc_curr = MPU_Reference.document(user_key).collection(u"Cuentas").document(acc).get().to_dict()
    acc_curr["Saldo"] += float(value)
    MPU_Reference.document(user_key).collection(u"Cuentas").document(acc).set(acc_curr);

def registerOps (user_key, ops):
    return MPU_Reference.document(user_key).collection(u"Ops").add(ops.to_dict());    

def registerToPay (user_key, topay):
    return MPU_Reference.document(user_key).collection(u"ToPay").add(topay.to_dict());

def move_money (user, psw, ops):
    """
    user: El usuario al cual se le realiza la transferencia
    psw: La contraseña de ese usuario
    ops: Objeto ops con datos necesarios
    """
    # chequeo que sea el usuario mediante su psw
    auth_data = LoginAuth(user, psw)
    auth = auth_data["auth"]
    if auth:
        try:
            user_key =  auth_data["user_key"]
            if ops.cuotes > 1:           
                # pago la primer cuota y agrego el primer Ops             
                cuota = ops.value * (1 + ops.interest/100)
                ops.value = cuota 
                discount_from_account(user_key, ops.acc, cuota)
                updt_time, ops_ref = registerOps(user_key, ops)
                # leo la fecha de vencimiento de la tarjeta asociada a acc
                venc = MPU_Reference.document(user_key).collection(u"Cuentas").document(ops.acc).get().to_dict()["Vencimiento"]
                venc = str(venc)[:19]
                fecha_j = datetime.datetime.strptime(str(venc), "%Y-%m-%d %H:%M:%S")
                topays_ref = []
                # creo toPays por cada cuota faltante
                for j in range (ops.cuotes-1):
                    # registro cada to pay, incrementando la fecha de pago de a 1 mes
                    fecha_j = fecha_j + relativedelta(months=1)
                    topay_j = ToPay(ops.category, ops.detail, ops.acc, fecha_j, cuota, j, ops.cuotes)
                    tp_updt_time, to_pay_ref = registerToPay(user_key, topay_j)
                    topays_ref.append(to_pay_ref.id)
                    
                return {
                    "status": "OK",
                    "info": f"Se actualizo el saldo de la cuenta {ops.acc}",
                    "OPS_ID": ops_ref.id,
                    "time": updt_time,
                    "TO_PAYS": topays_ref
                }    
            else:      
                # agregar/descontar de la cuenta particular acc
                discount_from_account (user_key, ops.acc, ops.value)
                # agregar a ops 
                updt_time, ops_ref = registerOps (user_key, ops)

                return {
                    "status": "OK",
                    "info": f"Se actualizo el saldo de la cuenta {ops.acc}",
                    "OPS_ID": ops_ref.id,
                    "time": updt_time
                }    

        except KeyError as e:
            print ("MoveMoney: ", str(e))
            return { "status": "Bad", "error": "No se realizo la transferencia", "info": "No es una tarjeta de credito" }   

        except Exception as e:
            print ("MoveMoney: ", str(e))
            return { "status": "Bad", "error": "No se realizo la transferencia"}

    else:
        return {"status": "OK", "error": "Error de autenticacion."}
