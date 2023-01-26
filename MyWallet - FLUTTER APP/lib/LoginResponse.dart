import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LoginResponse extends StatefulWidget{
  const LoginResponse({Key? key, required this.USER, required this.PWD}) : super(key: key);
  final String USER;
  final String PWD;
  @override
  State<LoginResponse> createState() => _LogInResponseState();
}

class _LogInResponseState extends State<LoginResponse> {

  late Future<Map<String, dynamic>> log_response;

  @override
  void initState() {
    super.initState();
    log_response = fetchLog();
  }

  Future<Map<String, dynamic>> fetchLog() async {
    final response = await http.get(Uri.parse('http://sebasandres.pythonanywhere.com/logIn/1/2'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("My Wallet 💵")),
        body:
        FutureBuilder<Map<String, dynamic>>(
          future: log_response,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.toString());
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        )
    );
  }

}