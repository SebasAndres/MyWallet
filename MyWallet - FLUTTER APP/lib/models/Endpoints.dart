
class Endpoints {
  Uri log_in (String user, String pwd) {
    return Uri.parse('http://sebasandres.pythonanywhere.com/logIn/'+user+"/"+pwd);
  }

  Uri home (String user_key){
    return Uri.parse('http://sebasandres.pythonanywhere.com/home/'+user_key);
  }

  Uri transferir_1c (String user, String psw, String cuenta, String concepto,
                     String detalle, double monto, bool esIngreso) {
    // Url para transferencia de unico pago
    if (esIngreso) {
      return Uri.parse('http://sebasandres.pythonanywhere.com/add_money/'+user+"/"+psw+"/"+cuenta+
                       "/"+monto.toString()+"/"+detalle+"/"+concepto);
    }
    else {
      return Uri.parse('http://sebasandres.pythonanywhere.com/spend_money/'+user+"/"+psw+"/"+cuenta+
                       "/"+monto.toString()+"/"+detalle+"/"+concepto);
    }
  }

  Uri get_account (String user_key, String acc){
    return Uri.parse('http://sebasandres.pythonanywhere.com/account/'+user_key+"/"+acc);
  }

}