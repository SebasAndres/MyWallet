
class Endpoints {
  Uri log_in (String user, String pwd) {
    return Uri.parse('http://sebasandres.pythonanywhere.com/logIn/'+user+"/"+pwd);
  }

  Uri home (String user_key){
    return Uri.parse('http://sebasandres.pythonanywhere.com/home/'+user_key);
  }
}