from django.db import models

# Create your models here.
class OPS ():
    def __init__ (self, category, acc, detail, date, value):
        self.category = category
        self.acc = acc
        self.detail = detail
        self.date = date
        self.value = float(value)
        # En caso de ser necesario, se agregan con el metodo posterior
        self.cuotes = 1
        self.interest = 0

    def set_cuotes_interest (self, ncuotes, interest):
        self.cuotes = int(ncuotes)
        self.interest = float(interest)

    def to_dict (self):
        if self.cuotes > 1:
            return {
                "Categoria": self.category,
                "Cuenta": self.acc,
                "Cuotas": self.cuotes,
                "Detalle": self.detail,
                "Fecha": self.date,
                "Monto": self.value
            }
        else:
             return {
                "Categoria": self.category,
                "Cuenta": self.acc,
                "Detalle": self.detail,
                "Fecha": self.date,
                "Monto": self.value
            }           

class ToPay ():
    def __init__ (self, category, detail, account, date_to_pay, cuote, cuote_i, n_cuotes):
        self.cat = category
        self.det = detail 
        self.acc = account
        self.date_to_pay = date_to_pay
        self.cuote = cuote # valor de la cuota
        self.cuote_i = cuote_i # numero de cuota a la que refiere
        self.n_cuotes = n_cuotes # cantidad de cuotas asociadas
    
    def to_dict (self):
        return {
            "Categoria": self.cat,
            "Detalle": self.det,
            "Cuenta": self.acc,
            "Monto": self.cuote,
            "Fecha Pago": self.date_to_pay,
            "nCuota": self.cuote_i,
            "cantCuotas": self.n_cuotes
        }