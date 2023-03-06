import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from dateutil.relativedelta import relativedelta

from API.models import ToPay, User
import datetime

# Use a service account.
cred = credentials.Certificate('API/scripts/firestore_key.json')
app = firebase_admin.initialize_app(cred)
db = firestore.client()

LogInReference = db.collection("Log In")
MPU_Reference = db.collection("MovimientosPorUsuario")

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

    pie_chart_categories_data = dict()
    current_date_ref = date_to_ref(datetime.datetime.now())
    ops_span = MPU_Reference.document(user_key).collection("Ops")\
                            .document(current_date_ref).get().to_dict()
    for ops_key in ops_span:
        ops_j = ops_span[ops_key]
        try:
            pie_chart_categories_data[ops_j['Categoria']] += ops_j['Monto']
        except KeyError:
            pie_chart_categories_data[ops_j['Categoria']] = ops_j['Monto']

    user_accounts = list ()
    for acc in user_coll.collection("Cuentas").stream():
        user_accounts.append(acc.id)

    return {
        "nombre": user_data_log["User"],
        "pie_chart": pie_chart_categories_data,
        "cuentas": user_accounts,
        "categorias": user_data_log["categorias"],
        "foto": user_data_log["Pic"],
        "ult_op": user_data_log["ult_op"],
        "nivel_gasto": "NORMAL 😃"
    }

def date_to_ref (date):
    c_year = str(date.year)
    return date.strftime("%b").lower()+"-"+''.join(c_year)

def read_account (user_key, acc):
    return MPU_Reference.document(user_key).collection("Cuentas").document(acc).get().to_dict()

def discount_from_account (user_key, acc, value):
    acc_curr = read_account(user_key, acc)
    acc_curr["Saldo"] += float(value)
    MPU_Reference.document(user_key).collection("Cuentas").document(acc).set(acc_curr);

def registerOps (user_key, ops):
    document_date_ref = ops.collection_ref
    ops_key = ops.id
    try:
        return MPU_Reference.document(user_key).collection("Ops"). \
                            document(document_date_ref).update({ops_key: ops.to_dict()});    
    except Exception as e:
        if 'No document to update' in str(e):
            print (f'* :: Primer transferencia del mes --> creando documento {document_date_ref} para {user_key}')
            return MPU_Reference.document(user_key).collection("Ops"). \
                                document(document_date_ref).set({ops_key: ops.to_dict()});    
        else:
            print ("Excepcion rara en registerOps: ", e)

def move_money (user, psw, ops):
    """
    Registra OPS y ToPay, hace los movimientos entre las respectivas cuentas
    Params:
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
                updt_time = registerOps(user_key, ops).update_time

                # update last op date
                LogInReference.document(user_key).update({"ult_op": updt_time})

                # leo la fecha de vencimiento de la tarjeta asociada a acc
                venc = MPU_Reference.document(user_key).collection("Cuentas") \
                                    .document(ops.acc).get().to_dict()["Vencimiento"]
                venc = str(venc)[:19]
                fecha_j = datetime.datetime.strptime(str(venc), "%Y-%m-%d %H:%M:%S")
                topays_ref = []

                # creo toPays por cada cuota faltante
                for j in range (ops.cuotes-1):
                    # registro cada to pay, incrementando la fecha de pago de a 1 mes
                    fecha_j = fecha_j + relativedelta(months=1)
                    topay_j = ToPay(ops.category, ops.detail, ops.acc, fecha_j, cuota, j, ops.cuotes)
                    registerOps(user_key, topay_j)
                    topays_ref.append((topay_j.collection_ref, topay_j.id))

                return {
                    "status": "OK",
                    "info": f"Se actualizo el saldo de la cuenta {ops.acc}, en concepto de {ops.category}",
                    "time": updt_time,
                    "TO_PAYS": topays_ref
                }    

            else:      
                # agregar/descontar de la cuenta particular acc
                discount_from_account(user_key, ops.acc, ops.value)
                # agregar a ops 
                updt_time = registerOps(user_key, ops).update_time
                # update last op date
                LogInReference.document(user_key).update({"ult_op": updt_time})
                return {
                    "status": "OK",
                    "info": f"Se actualizo el saldo de la cuenta {ops.acc}",
                    "OPS_DATE_DOC": ops.id,
                    "collection_ref": ops.collection_ref,
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

def register_new_user (user:User):
    users_docs = LogInReference.stream()
    for usr_doc in users_docs:
        if user.name == usr_doc["User"]:
            return { "error" : "username already exists!" }        
    # registro en ambas colecciones
    LogInReference.add(user.log_in_data())
    MPU_Reference.add(user.MPU_data())