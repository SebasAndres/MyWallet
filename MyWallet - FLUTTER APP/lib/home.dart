import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mywallet/models/photo_heroe.dart';
import 'package:mywallet/utils.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:pie_chart/pie_chart.dart';
import 'models/Account.dart';
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

  Future<Map<String, dynamic>> read_selected_account (String acc) async {
    final response = await http.get(my_endpoints.get_account(USER_KEY, acc));
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
  String cuentaElegida = "Efectivo";
  String conceptoElegido = "Comida";
  TextEditingController DetalleText = TextEditingController();
  TextEditingController MontoText = TextEditingController();
  double PROFILE_ROW_SPACE_WIDTH = 25;
  double PROFILE_ROW_SPACE_HEIGHT = 10;

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
                        height: 410,
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
                                    controller: MontoText,
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
                                    controller: DetalleText,
                                  ),
                                ),
                                SizedBox(height:10),
                                ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    primary: Colors.white, //<-- SEE HERE
                                  ),
                                  child: Text("Transferir"),
                                  onPressed: () async {
                                    String cuenta = cuentaElegida;
                                    String concepto = conceptoElegido;
                                    String detalle = DetalleText.text;
                                    double monto = double.parse(MontoText.text);
                                    if (detalle.isEmpty) { detalle = "_"; }
                                    var server_resp = await http.get(my_endpoints.transferir_1c(curr_usr.nombre, curr_usr.psw, cuenta, concepto, detalle, monto));
                                    var data = jsonDecode(server_resp.body);
                                    if (data["status"] == "OK"){
                                      showAlertDialog(context, "Se realizo la transferencia!\n"+data["info"]);
                                    }
                                    else { 
                                      showAlertDialog(context, "Error! No se realizo la transferencia. ");
                                    }
                                    setState(() {});
                                  } , //
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
            return const CircularProgressIndicator();
          },
        )
    );
  }

  Widget topCardWidget (User usr) {
    return Container(
      color: Colors.indigo[300],
      child:
      Row (
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 70, // Image radius
                backgroundImage: NetworkImage(usr.foto),
              ),
            ],
          ),
          SizedBox(width:PROFILE_ROW_SPACE_WIDTH),
          Column(
            children: [
              SizedBox(height:PROFILE_ROW_SPACE_HEIGHT*1.2),
              Text("Hola "+ usr.nombre + "!👋🧉", style: HOME_FONT_STYLE, overflow: TextOverflow.ellipsis),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children:[
                  SizedBox(height:PROFILE_ROW_SPACE_HEIGHT),
                  Text("Tu nivel de gasto está "+usr.nivel_gasto, style:GoogleFonts.cabinCondensed (color: Colors.white, fontSize: 14)),
                  SizedBox(height:PROFILE_ROW_SPACE_HEIGHT/2),
                  Text("0 Notificaciones pendientes.", style:GoogleFonts.cabinCondensed (color: Colors.white, fontSize: 14)),
                  SizedBox(height:PROFILE_ROW_SPACE_HEIGHT/2),
                  Text("ult. operación: 31/01/23 16:30", style:GoogleFonts.cabinCondensed (color: Colors.white, fontSize: 14)),
                  SizedBox(height:PROFILE_ROW_SPACE_HEIGHT),
                  ElevatedButton(
                    onPressed: (){},
                    child: Text("Ver perfil"),
                  )
                ]
              )
            ],
          )
        ],
      ),
    );
  }

  Widget bottomCardWidget (User user) {
    Map<String, double> usr_egresos_map = user.EgresosMap();
    if (usr_egresos_map.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Egresos", style: HOME_FONT_STYLE),
          PieChart(
            dataMap: usr_egresos_map,
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
    else {
      return Text("Todavia no tenés ningun gasto! ", style: HOME_FONT_STYLE);
    }

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
                body:
                  FutureBuilder<Map<String, dynamic>>(
                    future: read_selected_account(c),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Account m_account = new Account (snapshot.data!);
                        return PRINT_ACCOUNT_CARD(m_account);
                      }
                      else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    }
                  )
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

  Widget PRINT_ACCOUNT_CARD (Account acc) {
    return Column(
      children: [
        PhotoHero(
          photo: 'assets/img/icon.png',
          descr: acc.nombre,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}
