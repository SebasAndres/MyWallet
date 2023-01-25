import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.USER_KEY}) : super(key: key);
  final String USER_KEY;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  final NAME = "Sebastian";

  final dataMap = <String, double>{
    "Flutter": 5,
    "Python": 10,
  };

  final List<String> images = ["Me", "You", "Foo", "Baa"];
  final PageController controller = PageController(viewportFraction:0.8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Wallet - Home"),
        ),
        body:
          BUILD_HOME_FOR_USER ()
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
                  Text("Bienvenido, ${NAME}", style: GoogleFonts.bentham(fontSize: 30)),
                ],
              )
            ),
            SizedBox(height: 20),
            SlimyCard(
              color: Colors.indigo[300],
              topCardWidget: topCardWidget(),
              bottomCardWidget: bottomCardWidget(),
            ),
            SizedBox(height: 20),
          ],
        );
      }),
    );
  }

  Widget topCardWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PieChart(
          dataMap: dataMap,
          chartType: ChartType.ring,
          baseChartColor: Colors.grey[50]!.withOpacity(0.15),
          chartValuesOptions: const ChartValuesOptions(
            showChartValuesInPercentage: true,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Egresos',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        SizedBox(height: 10),
      ],
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
            'Este grafico representa tus egresos entre el periodo X - Y.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  List<Widget> BUILD_BANK_CARDS (){
    Card c = Card(child: Text("a"));
    return [c, c, c];
  }

  Widget CardMovie () {
    return Card(
        shadowColor: Theme.of(context).accentColor,
        elevation: 5,
        child:
        Column(
          children: [
            Text("Movie", style: GoogleFonts.bentham(fontSize: 10)),
          ],
        )
    );
  }

}
