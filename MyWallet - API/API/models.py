from django.db import models

# Create your models here.
class OPS ():
    def __init__ (self, category, acc, detail, date, value):
        self.category = category
        self.acc = acc
        self.detail = detail
        self.date = date
        self.value = float(value)
        self.id = str(self.date)[:19]
        self.collection_ref = self.date_to_ref()
        # En caso de ser necesario, se agregan con el metodo posterior
        self.cuotes = 1
        self.interest = 0

    def set_cuotes_interest (self, ncuotes, interest):
        self.cuotes = int(ncuotes)
        self.interest = float(interest)

    def date_to_ref (self):
        c_year = str(self.date.year)
        return self.date.strftime("%b").lower()+"-"+''.join(c_year)

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

class ToPay (OPS):
    def __init__ (self, category, detail, account, date_to_pay, cuote, cuote_i, n_cuotes):
        super().__init__(category=category, acc=account, detail=detail, date=date_to_pay, value=cuote)
        self.cuote_i = cuote_i # numero de cuota a la que refiere
        self.n_cuotes = n_cuotes # cantidad de cuotas asociadas

    def to_dict (self):
        return {
            "Categoria": self.category,
            "Detalle": self.detail,
            "Cuenta": self.acc,
            "Monto": self.value,
            "Fecha": self.date, # fecha de pago
            "nCuota": self.cuote_i,
            "cantCuotas": self.n_cuotes
        }