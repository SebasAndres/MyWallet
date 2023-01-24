import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:mywallet/models/user.dart';
import "utils.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.USER_KEY, required this.NAME}) : super(key: key);
  final String USER_KEY;
  final String NAME;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  // Inicializo USER como vacio
  User USER = new User();

  // PIE CHART
  final colorList = <Color>[
    Colors.greenAccent,
    Colors.white
  ];

  final dataMap = <String, double>{
    "Flutter": 5,
    "Python": 10,
  };

  @override
  Widget build(BuildContext context) {

    CollectionReference MPU = FirebaseFirestore.instance.collection('MovimientosPorUsuario');

    return Scaffold(
        appBar: AppBar(
          title: Text("My Wallet - Home"),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: MPU.doc("UserKey1").collection("MisDatos").doc("Categorias").get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, double> data = snapshot.data!.data() as Map<String, double>;
              USER.name = widget.NAME;
              USER.key = widget.USER_KEY;
              USER.load_data(data);
              return BUILD_HOME_FOR_USER ();
            }
            else if (snapshot.connectionState == ConnectionState.none) {
              return Text("No data");
            }
            return Center(
              child:
              Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(),
                  )
                ],
              ),
            );
          },
        )
    );
  }

  Widget BUILD_HOME_FOR_USER (){
    return StreamBuilder(
      initialData: false,
      stream: slimyCard.stream,
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(height: 20),
            Card(
              shadowColor: Theme.of(context).accentColor,
              elevation: 5,
              child:
              Column(
                children: [
                  Text("Bienvenido, ${USER.name}", style: GoogleFonts.bentham(fontSize: 30)),
                ],
              )
            ),
            SizedBox(height: 20),
            SlimyCard(
              color: Colors.indigo[300],
              topCardWidget: topCardWidget(),
              bottomCardWidget: bottomCardWidget(),
            ),
          ],
        );
      }),
    );
  }

  Widget bottomCardWidget() {
    return Column(
      children: [
        Text(
          'Grafico de egresos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        Expanded(
          child: Text(
            'FlutterDevs specializes in creating cost-effective and efficient '
                'applications with our perfectly crafted,creative and leading-edge '
                'flutter app development solutions for customers all around the globe.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget topCardWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PieChart(
          dataMap: USER.spent_map,
          chartType: ChartType.ring,
          baseChartColor: Colors.grey[50]!.withOpacity(0.15),
          colorList: colorList,
          chartValuesOptions: const ChartValuesOptions(
            showChartValuesInPercentage: true,
          ),
          totalValue: 20,
        ),
        SizedBox(height: 20),
        Text(
          'Egresos',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(height: 10),
      ],
    );
  }

}
