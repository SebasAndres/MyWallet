
class Endpoints {
  final urls = <String, String> {
    "login": "http://127.0.0.1:8000/logIn/",
    "addmoney": "http://127.0.0.1:8000/add_money/"
  };

  Uri log_in (String user, String pwd) {
    return Uri.parse(urls["login"]!+"/"+user+"/"+pwd);
  }
}