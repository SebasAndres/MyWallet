import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mywallet/models/photo_heroe.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:pie_chart/pie_chart.dart';
import "models/Endpoints.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.USER_KEY}) : super(key: key);
  final String USER_KEY;
  @override
  State<HomePage> createState() => _HomePageState(USER_KEY: USER_KEY);
}

class _HomePageState extends State<HomePage> {

  String USER_KEY;
  _HomePageState({required this.USER_KEY});

  late Future<Map<String, dynamic>> server_response_user;
  Endpoints my_endpoints = Endpoints();

  @override
  void initState() {
    super.initState();
    server_response_user = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final response = await http.get(my_endpoints.home(USER_KEY));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  // CONFIG VIEWS
  TextStyle HOME_FONT_STYLE = GoogleFonts.cabinCondensed (color: Colors.white, fontSize: 25);
  TextStyle HOME_FONT_STYLE_DARK = GoogleFonts.cabinCondensed (color: Colors.black, fontSize: 20);
  TextStyle HOME_TITLE_FONT = GoogleFonts.bentham (fontSize: 30, color: Colors.white);
  SizedBox SPACE = SizedBox (height: 15);
  bool showAccounts = false;

  // SAMPLE DATA
  final NAME = "Sebastian";
  final dataMap = <String, double>{
    "Flutter": 5,
    "Python": 10,
  };
  String cuentaElegida = "Efectivo";
  final List<String> CONCEPTOS = ["Futbol", "Gimnasio", "Joda", "Ropa"];
  String conceptoElegido = "Comida";
  String USER_PICTURE_URL = "https://avatars.githubusercontent.com/u/69599597?v=4";

  @override
  Widget build(BuildContext context) {
    // timeDilation = 1.0;
    return Scaffold(
        appBar: AppBar(
          title: Text("MyWallet - Home 💵"),
        ),
        body:
        FutureBuilder<Map<String, dynamic>>(
          future: server_response_user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              User curr_usr = new User (snapshot.data!);

              return  StreamBuilder(
                initialData: false,
                stream: slimyCard.stream,
                builder: ((BuildContext context, AsyncSnapshot snapshot) {
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      SPACE,
                      AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: 100,
                          height: 60,
                          child:
                          Card (
                              elevation: 20,
                              color: Colors.grey[100],
                              child: Row(
                                children: [
                                  SizedBox (width: 10),
                                  Text ("Mi PERFIL 👤", style: HOME_FONT_STYLE_DARK),
                                ],
                              )
                          )
                      ),
                      SPACE,
                      SlimyCard(
                        color: Colors.indigo[300],
                        width: 380,
                        topCardHeight: 250,
                        bottomCardHeight: 285,
                        topCardWidget: topCardWidget(curr_usr),
                        bottomCardWidget: bottomCardWidget(curr_usr),
                      ),
                      SPACE,
                      AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: 100,
                          height: 60,
                          child:
                          Card (
                              elevation: 30,
                              color: Colors.deepPurple,
                              child: Row(
                                children: [
                                  SizedBox (width: 10),
                                  Text ("MOVIMIENTOS 💱", style: HOME_FONT_STYLE),
                                ],
                              )
                          )
                      ),
                      SizedBox(
                        height: 400,
                        child: Card(
                            color: Colors.indigo[300],
                            child: Column(
                              children: [
                                Text("Cuenta", style: GoogleFonts.abel(fontSize: 25, color: Colors.white)),
                                SizedBox(
                                    width: 250,
                                    child:
                                    DropdownButton<String>(
                                      value: cuentaElegida,
                                      icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      style: const TextStyle(color: Colors.black),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          cuentaElegida = value!;
                                        });
                                      },
                                      items: curr_usr.cuentas.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    )
                                ),
                                Text("Monto", style: GoogleFonts.abel(fontSize: 25, color: Colors.white)),
                                SizedBox(
                                  width: 250,
                                  child:
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        labelText: "Ingresa el monto",
                                        border: OutlineInputBorder()
                                    ),
                                    cursorColor: Colors.white,
                                  ),
                                ),
                                Text("Concepto", style: GoogleFonts.abel(fontSize: 25, color: Colors.white)),
                                SizedBox(
                                    width: 250,
                                    child:
                                    DropdownButton<String>(
                                      value: conceptoElegido,
                                      icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      style: const TextStyle(color: Colors.black),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          conceptoElegido = value!;
                                        });
                                      },
                                      items: curr_usr.categorias.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    )
                                ),
                                Text("Detalle", style: GoogleFonts.abel(fontSize: 25, color: Colors.white)),
                                SizedBox(
                                  width: 250,
                                  child:
                                  TextField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        labelText: "Detalle",
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
                                  child: Text("Transferir"),
                                  onPressed: () {} , //
                                )
                              ],
                            )
                        ),
                      ),
                      SPACE,
                      AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: 100,
                          height: 60,
                          child:
                          InkWell (
                              child:
                              Card (
                                  elevation: 5,
                                  color: Colors.black,
                                  shadowColor: Colors.deepPurpleAccent,
                                  child: Row(
                                    children: [
                                      SizedBox (width: 10),
                                      Text ("Mis CUENTAS 🏦", style: HOME_FONT_STYLE),
                                    ],
                                  )
                              ),
                              onTap: () => {
                                setState(() { showAccounts = !showAccounts; }
                                )
                              }
                          )
                      ),
                      SPACE,
                      showAc(curr_usr)
                    ],
                  );
                }),
              );
            }
            else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        )
    );
  }

  Widget topCardWidget (User usr) {
    return Container(
      color: Colors.white,
      child:
      Row (
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container (
                color: Colors.black,
                child:
                  Image.network(usr.foto, width: 200, height: 200)
              )
            ],
          ),
          Column()
        ],
      ),
    );
  }

  Widget bottomCardWidget (User user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Egresos", style: HOME_FONT_STYLE),
        PieChart(
          dataMap: user.EgresosMap(),
          chartType: ChartType.ring,
          baseChartColor: Colors.indigo[200]!,
          animationDuration: const Duration(milliseconds: 800),
          chartValuesOptions: const ChartValuesOptions(
            showChartValuesInPercentage: true,
          ),
          legendOptions: LegendOptions(
            legendTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
        ),
      ],
    );
  }

  Widget showAc (User user){
    if (showAccounts) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: GET_ACCOUNT_HEROES(user),
      );
    }
    else {
      return Column();
    }
  }

  List<Widget> GET_ACCOUNT_HEROES (User user){
    List<Widget> banks_widget_list = [];
    for (String c in user.cuentas) {
      PhotoHero account_hero = PhotoHero(
          photo: 'assets/img/icon.png',
          descr: c,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return Scaffold(
                appBar: AppBar(
                  title: Text(c),
                ),
                body: Container(
                  // The blue background emphasizes that it's a new route.
                  color: Colors.lightBlueAccent,
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.topLeft,
                  child: PhotoHero(
                    photo: 'assets/img/icon.png',
                    descr: c,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
              }
            ));
          }
      );
      banks_widget_list.add(account_hero);
      banks_widget_list.add(SizedBox(height:10));
    }
    return banks_widget_list;
  }

}
