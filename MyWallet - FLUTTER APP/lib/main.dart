import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mywallet/home.dart';
import "utils.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: LogInPage(title: 'Log In'),
    );
  }
}

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  void initState() {
    super.initState();
  }

  // PAGE CONFIGS
  bool loginActive = false;

  // INPUT CONTROLLERS
  final nameInput_ctrl = TextEditingController();
  final pwdInput_ctrl = TextEditingController();

  Center PreviewLogin = Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[ Text('Log In 🤙', style: TextStyle(fontSize: 20, color: Colors.white)) ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Wallet 💵"),
        ),
        body: GestureDetector(
          onTap: () { setState(() { loginActive = !loginActive;}); },
          child: Center(
            child:
            AnimatedContainer(
                width: loginActive ? 350.0 : 300.0,
                height: loginActive ? 360.0 : 100.0,
                color: loginActive ? Colors.indigo[300]: Colors.black,
                alignment: loginActive ? Alignment.center : AlignmentDirectional.topCenter,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: loginActive ? Wrap(
                  direction: Axis.vertical,
                  spacing: 20,
                  children: [
                    Text("User", style: GoogleFonts.abel(fontSize: 25, color: Colors.white)),
                    SizedBox(
                      width: 250,
                      child:
                      TextField(
                        controller: nameInput_ctrl,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Ingresa el usuario",
                          border: OutlineInputBorder(),
                        ),
                        cursorColor: Colors.white,
                      ),
                    ),
                    Text("Password", style: GoogleFonts.abel(fontSize: 25, color: Colors.white)),
                    SizedBox(
                      width: 250,
                      child:
                      TextField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: pwdInput_ctrl,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelText: "Ingresa la contraseña",
                            border: OutlineInputBorder()
                        ),
                        cursorColor: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                        primary: Colors.white, //<-- SEE HERE
                      ),
                      child: Text("Ingresar"),
                      onPressed: () {
                        // AUTH PROCESS
                        String user = nameInput_ctrl.text;
                        String pwd = pwdInput_ctrl.text;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(USER_KEY: "UserKey1")),
                        );
                      } , //
                    )
                  ],
                ) : PreviewLogin
            ),
          ),
        )
    );
  }

  void errorLogIn (BuildContext context) {
    showAlertDialog(context, "No se encontro al usuario");
    nameInput_ctrl.text = "";
    pwdInput_ctrl.text = "";
  }


}